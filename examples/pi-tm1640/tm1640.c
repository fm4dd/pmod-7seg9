/* ------------------------------------------------------- *
 * file:      tm1640.c                                     *
 * purpose:   Functions for serial data communication with *
 *            a Titan Micro TM1640 LED driver IC. Belongs  * 
 *            to the pi-tm1640 package. Functions called   *
 *            from settm1640.c, globals are in ttm1640.h.  *
 *                                                         *
 * Requires:   GPIOD: apt install gpiod libgpiod-dev       *
 *                                                         *
 * author:    13/09/2021 Frank4DD                          *
 * ------------------------------------------------------- */
#include "tm1640.h"
#include "font.h"

/* ------------------------------------------------------- */
/* Global variables                                        */
/* ------------------------------------------------------- */
struct gpiod_chip *chip;
extern int verbose;

/* ------------------------------------------------------- */
/* str_reverse() reverse a null-terminated string in place */
/* ------------------------------------------------------- */
// reverse the given null-terminated string in place
void str_reverse(char *str) {
  if (str) {
    char * end = str + strlen(str) - 1;

    // swap the values in the two given variables
    // XXX: fails when a and b refer to same memory location
#   define XOR_SWAP(a,b) do\
    {\
      a ^= b;\
      b ^= a;\
      a ^= b;\
    } while (0)

    // walk inwards from both ends of the string, 
    // swapping until we get to the middle
    while (str < end) {
      XOR_SWAP(*str, *end);
      str++;
      end--;
    }
#   undef XOR_SWAP
  }
}

/* ------------------------------------------------------- */
/* SwitchTwoBits() helper function for tm1640_vertical()   */
/* ------------------------------------------------------- */
unsigned char SwitchTwoBits(unsigned char Byte, int SwapBit1, int SwapBit2) {
    unsigned char Bit1;
    unsigned char Bit2;
    unsigned char XOR;

    Bit1=(Byte>>SwapBit1) & 1; // Extract first bit
    Bit2=(Byte>>SwapBit2) & 1; // Extract second bit

   // --------------------------------------------------------
   // Find XOR - this is 1 if the two bits are different
   // --------------------------------------------------------
   XOR=Bit1^Bit2;
    
   return (Byte^(XOR<<SwapBit1 | XOR<<SwapBit2));
}

/* ------------------------------------------------------- */
/* Invert the displasy bit pattern to vertical orientation */
/* ------------------------------------------------------- */
char tm1640_vertical(char input) {
   char invert = input;

   // --------------------------------------------------------
   // Call swap-two-bits function. If two bits are the same,
   // we don't check but swap them anyway
   // --------------------------------------------------------
   invert=SwitchTwoBits(invert,0,3);
   invert=SwitchTwoBits(invert,1,4);
   invert=SwitchTwoBits(invert,2,5);

   if(verbose == 1) printf("  Debug: invert "BYTE_TO_BINARY_PATTERN" = "BYTE_TO_BINARY_PATTERN"\n",
                                 BYTE_TO_BINARY(input), BYTE_TO_BINARY(invert));
   return invert;
}

/* ------------------------------------------------------- */
/* tm1640_write() Writes a string of digits to the display */
/* ------------------------------------------------------- */
int tm1640_write(tm1640_display* display, int offset,
                 char *string, char length, int invert) {

   char buffer[DISPLAYSTR];           // 7-Segment LED bit pattern
   memset(buffer, 0, sizeof(buffer)); // Start with all segments off

   if(verbose == 1) printf("Debug: tm1640_write(s=%s l=%d i=%d):\n",
                            string, length, invert);

   if(invert == 1) str_reverse(string);// reverse the string

   int c=0;
   for (c=0; c<length; c++) {          // cycle through all chars
      // --------------------------------------------------------
      // Check string len, error on overflow. Allow for extra dot
      // --------------------------------------------------------
      if (((string[c] == '.') && (offset + c) >= DISPLAYSTR+1) ||
          ((string[c] != '.') && (offset + c) >= DISPLAYSTR)) {
         printf("Error: display string size %d\n", length);
         gpiod_chip_close(chip);
         exit(127);
      }

      // --------------------------------------------------------
      // Translate characters to 7-segment bit patterns
      // --------------------------------------------------------
      buffer[c] = tm1640_asc_to_7seg(string[c]);
      if(invert == 1) buffer[c] = tm1640_vertical(buffer[c]);
      if(verbose == 1) printf("  Debug: char %c = "BYTE_TO_BINARY_PATTERN"\n",
                                 string[c], BYTE_TO_BINARY(buffer[c]));

      // -----------------------------------------------------------
      // Merge dot with the previous char. Requires string not start
      // with a dot and previous character not already having a dot.
      // -----------------------------------------------------------
      if(string[c] == '.' && c!=0 && !(0b10000000 & buffer[c-1])) {
         buffer[c-1] |= 0b10000000; // add dot to previous bit pattern
         length--;                  // reduce string length - 1
         c--;                       // reduce output counter - 1
         string = &string[1];       // move string char one forward
      }
   }

   // -----------------------------------------------------------
   // If the string is smaller than display size, we fill in '\0'
   // -----------------------------------------------------------
   int diff = DISPLAYSTR-c; // calculate remainder space
   if(diff > 0) memset(&buffer[c], 0, (sizeof(char)*diff));

   // -----------------------------------------------------------
   // Now start writing to the display: Send CMD1 "set data"
   // -----------------------------------------------------------
   tm1640_sendCmd(display, 0x44);
   usleep(2);

   // -----------------------------------------------------------
   // Finish writing to the display: Send CMD2 "set address"+data
   // -----------------------------------------------------------
   tm1640_send(display, 0xC0 + offset, buffer, DISPLAYSTR);
   if(verbose == 1) printf("...write done\n");
   return 0;
}

/* ------------------------------------------------------- */
/* tm1640_asc_to_7seg() helper func converts chars to bits */
/* ------------------------------------------------------- */
char tm1640_asc_to_7seg(char ascii) {
   if (ascii < FONT_FIRST_CHAR || ascii > FONT_LAST_CHAR) {
      return 0; // skip if char is outside our font table
   }
   return DEFAULT_FONT[ascii - FONT_FIRST_CHAR];
}

void tm1640_setColon(tm1640_display* display, int num, int state) {
   char colon;
   if(state == 1) colon = 0b00000011;
   else colon = 0b00000000;
   tm1640_sendCmd(display, 0x44);
   usleep(2);
   tm1640_send(display, 0xC0 + 8 + num, &colon, 1);
}

void tm1640_setDegree(tm1640_display* display, int num, int state) {
   char degree;
   if(state == 1) degree = 0b00000001;
   else degree = 0b00000000;
   tm1640_sendCmd(display, 0x44);
   usleep(2);
   tm1640_send(display, 0xC0 + 8 + num, &degree, 1);
}

/* ------------------------------------------------------- */
/* tm1640_clear() clears display for all digits            */
/* ------------------------------------------------------- */
void tm1640_clear(tm1640_display* display) {
   char buffer[16];
   memset( buffer, 0x00, 16 );
   tm1640_send(display, 0xC0, buffer, 16);
}

/* ------------------------------------------------------- */
/* tm1640_on() sends the display on command + brighntess   */
/* ------------------------------------------------------- */
void tm1640_on(tm1640_display* display, char brightness) {
   if (brightness < 0) brightness = 0;
   if (brightness > 7) brightness = 7;
   tm1640_sendCmd(display, 0x88 + brightness);
   if(verbose == 1) printf("Debug: tm1640_on(%d) complete\n", brightness);
}

/* ------------------------------------------------------- */
/* tm1640_off() sends the display off command 0x80         */
/* ------------------------------------------------------- */
void tm1640_off(tm1640_display* display) {
   tm1640_sendCmd(display, 0x80);
   if(verbose == 1) printf("Debug: tm1640_off() complete\n");
}

/* ------------------------------------------------------- */
/* tm1640_init() sets the GPIO lines as digital out, High  */
/* ------------------------------------------------------- */
tm1640_display* tm1640_init(unsigned int clockPin, unsigned int dataPin) {
   chip = gpiod_chip_open_by_name(CHIPNAME);
   if (!chip) { perror("Open chip failed\n"); return 0; }

   tm1640_display* display = malloc(sizeof(tm1640_display));
   memset(display, 0, sizeof(tm1640_display));

   // --------------------------------------------------------------
   // For the given list of pin #, obtain the line objects for each
   // --------------------------------------------------------------
   display->clockLine = gpiod_chip_get_line(chip, clockPin);
   if(! display->clockLine) {
         perror("Get GPIO clock line failed\n");
         gpiod_chip_close(chip);
         exit(127);
   } 
   display->dataLine = gpiod_chip_get_line(chip, dataPin);
   if(! display->dataLine) {
         perror("Get GPIO data line failed\n");
         gpiod_chip_close(chip);
         exit(127);
   }

   // --------------------------------------------------------------
   // Set lines as output, with initial logic level of '1' High
   // --------------------------------------------------------------
   gpiod_line_request_output(display->clockLine, PMOD, 1);
   gpiod_line_request_output(display->dataLine, PMOD, 1);
   if(verbose == 1) printf("Debug: tm1640_init(c=%d, d=%d)\n", clockPin, dataPin);
   return display;
}

/* ------------------------------------------------------- */
/* tm1640_sendRaw() sends one byte to IC CLK=L after start */
/* ------------------------------------------------------- */
void tm1640_sendRaw(tm1640_display* display, char out) {
   if(verbose == 1) printf("  Debug: tm1640_sendRaw(0x%02X) "BYTE_TO_BINARY_PATTERN, out, BYTE_TO_BINARY(out));
   int i;
   for(i = 0; i < 8; i++) {
      gpiod_line_set_value(display->dataLine, out & (1 << i)); // data
      gpiod_line_set_value(display->clockLine, 1);             // clock
      usleep(2);
      gpiod_line_set_value(display->clockLine, 0);             // clock
      usleep(2);
   }
   if(verbose == 1) printf(" ...complete\n");
}

/* ------------------------------------------------------- */
/* tm1640_send() sends command and data to the TM1640      */
/* ------------------------------------------------------- */
void tm1640_send(tm1640_display* display, char cmd, char * data, int len) {
   // Issue start command: CLK=H, Data changes from H->L
   gpiod_line_set_value(display->dataLine, 0);
   usleep(2);
   gpiod_line_set_value(display->clockLine, 0);
   usleep(2);
   tm1640_sendRaw(display, cmd);
   if(data != NULL) {
      int i;
      for(i = 0; i < len; i++) {
         tm1640_sendRaw(display, data[i]);
      }
   }
}

/* ------------------------------------------------------- */
/* tm1640_sendCmd() sends a command byte to the TM1640     */
/* ------------------------------------------------------- */
void tm1640_sendCmd(tm1640_display* display, char cmd ) {
   if(verbose == 1) printf("Debug: tm1640_sendCmd(0x%02X)\n", cmd);
//   tm1640_send(display, 0x40, 0 ,0);
   tm1640_send(display, cmd, 0, 0);
   gpiod_line_set_value(display->dataLine, 0);
   gpiod_line_set_value(display->clockLine, 0);
   usleep(2);
   gpiod_line_set_value(display->clockLine, 1);
   gpiod_line_set_value(display->dataLine, 1);
   if(verbose == 1) printf("...Cmd done\n");
}

void tm1640_destroy(tm1640_display* display) {
   free(display);
}
