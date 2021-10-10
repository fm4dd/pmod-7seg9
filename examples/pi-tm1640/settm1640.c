/* ------------------------------------------------------------ *
 * file:        settm1640.c                                     *
 * purpose:     controls the pmod-7seg9 module display. Writes  *
 *              up to 9 digits including colon to 9x7-segments  *
 *                                                              *
 * return:      0 on success, and -1 on errors.                 *
 *                                                              *
 * Requires:     GPIOD: apt install gpiod libgpiod-dev          *
 *                                                              *
 * compile:	gcc -o settm1640 i2c_tm1640.c settm1640.c       *
 *                                                              *
 * example:	./settm1640 -o 123456789                        *
 *                                                              *
 * author:      09/09/2021 Frank4DD                             *
 * ------------------------------------------------------------ */
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <ctype.h>
#include <unistd.h>
#include <string.h>
#include <getopt.h>
#include <time.h>
#include "tm1640.h"

/* ------------------------------------------------------------ *
 * Global variables and defaults                                *
 * ------------------------------------------------------------ */
int verbose = 0;
int argflag = 0;               // 1=dump, 2=info, 3=reset, 4=set
int inverted = 0;              // vertical inverted, 0=off, 1=on
int alignment = 0;             // left/right alignment. 0=right-aligned
int brightness = 4;            // LED brighness 0..7, default 4
unsigned int clockpin = 18;    // clock pin PMOD2RPI PMOD1 lower row
unsigned int datapin = 26;     // data pin PMOD2RPI PMOD1 lower row
char digits[DISPLAYSTR+2] = "";// output signal argument string
tm1640_display *d1;

/* ------------------------------------------------------------ *
 * print_usage() prints the programs commandline instructions.  *
 * ------------------------------------------------------------ */
void usage() {
   static char const usage[] = "Usage: settm1640 [-c <clockpin>] [-d <datapin>] -b <brightness>\n\
       settm1640 [-c <clockpin>] [-d <datapin>] [-i] -o <display-digits> [-a <l|r>]\n\
       settm1640 [-c <clockpin>] [-d <datapin>] -e\n\
       settm1640 [-c <clockpin>] [-d <datapin>] -o\n\
\n\
Command line parameters have the following format:\n\
   -a   left/right alignment either 'l' or 'r' (default)\n\
   -b   enable display with LED brightness 0..7\n\
        example: -b 5\n\
   -c   clock pin GPIO number\n\
   -d   data pin GPIO number\n\
   -e   empty (clear) the display\n\
   -i   vertical inverted (together with -w)\n\
   -o   display off switch\n\
   -w   1..9-digit output string to display\n\
        example: -o 12345678\n\
   -h   display this message\n\
   -v   enable debug output\n\
\n\
\n\
Usage examples:\n\
./settm1640 -c 18 -d 26 -b 2\n\
./settm1640 -c 18 -d 26 -e\n\
./settm1640 -c 18 -d 26 -o\n\
./settm1640 -c 18 -d 26 -w 876543210\n\n";
   printf(usage);
}

/* ------------------------------------------------------------ *
 * parseargs() checks the commandline arguments with C getopt   *
 * -b = argflag 1    -w = argflag 2     -o = argflag 3          *
 * ------------------------------------------------------------ */
void parseargs(int argc, char* argv[]) {
   int arg;
   opterr = 0;

   if(argc == 1) { usage(); exit(-1); }

   while ((arg = (int) getopt (argc, argv, "a:b:c:d:eiow:vh")) != -1) {
      switch (arg) {
         // arg -a + left/right alignment type: char, is either 'l' or 'r'
         case 'a':
            if(verbose == 1) printf("Debug: arg -a, value %s\n", optarg);
            if (optarg[0] == 'l') alignment = 1;
            else if (optarg[0] == 'r') alignment = 0;
            else {
               printf("Error: Cannot get valid -a alignment (should be 'l' or 'r').\n");
               exit(-1);
            }
            break;

         // arg -b + LED brightness value, type: int, example: 5 (0..7)
         case 'b':
            if(verbose == 1) printf("Debug: arg -b, value %s\n", optarg);
            argflag = 1;
            brightness = atoi(optarg);
            if (brightness < 0 || brightness > 7) {
               printf("Error: Cannot get valid -b brightness (should be 0..7).\n");
               exit(-1);
            }
            break;

         // arg -c + clock GPIO pin value, type: unsigned int
         case 'c':
            if(verbose == 1) printf("Debug: arg -c, value %s\n", optarg);
            clockpin = atoi(optarg);
            if (clockpin < 0 || clockpin > 100) {
               printf("Error: Cannot get valid -c pin number (should be 0..100).\n");
               exit(-1);
            }
            break;

         // arg -d + data GPIO pin value, type: unsigned int
         case 'd':
            if(verbose == 1) printf("Debug: arg -d, value %s\n", optarg);
            datapin = atoi(optarg);
            if (datapin < 0 || datapin > 100) {
               printf("Error: Cannot get valid -d pin number (should be 0..100).\n");
               exit(-1);
            }
            break;

         // arg -e empty (clear) the display
         case 'e':
            if(verbose == 1) printf("Debug: arg -e\n");
            argflag = 3;
            break;

         // arg -i vertically inverts the display
         case 'i':
            if(verbose == 1) printf("Debug: arg -i\n");
            inverted = 1;
            break;

         // arg -o off switch
         case 'o':
            if(verbose == 1) printf("Debug: arg -o\n");
            argflag = 4;
            break;

         // arg -w sets output digits, type: string example "123456789"
         case 'w':
            if(verbose == 1) printf("Debug: arg -w, value %s\n", optarg);
            argflag = 2;
            if (strlen(optarg) > DISPLAYSTR+1) { // We add 1 char for the dot
               printf("Error: display string argument to long.\n");
               exit(-1);
            }
            strncpy(digits, optarg, sizeof(digits));
            break;

         // get the usage output
         case 'h':
            usage(); exit(0);
            break;

         // arg -v verbose
         case 'v':
            verbose = 1; break;

         case '?':
            if(isprint (optopt))
               printf ("Error: Unknown option `-%c'.\n", optopt);
            else
               printf ("Error: Unknown option character `\\x%x'.\n", optopt);
            usage();
            exit(-1);
            break;

         default:
            usage();
            break;
      }
   }
}

int main(int argc, char *argv[]) {
   //int res = -1;       // res = function retcode: 0=OK, -1 = Error

   /* ---------------------------------------------------------- *
    * Process the cmdline parameters                             *
    * ---------------------------------------------------------- */
   parseargs(argc, argv);

   /* ----------------------------------------------------------- *
    * get current time (now), output at program start if verbose  *
    * ----------------------------------------------------------- */
   time_t tsnow = time(NULL);
   if(verbose == 1) printf("Debug: ts=[%lld] date=%s", (long long) tsnow, ctime(&tsnow));

   /* ----------------------------------------------------------- *
    * Open the I2C bus connecting to the i2c address 0x22 or 0x23 *
    * ----------------------------------------------------------- */
   d1 =  tm1640_init(clockpin, datapin);

   /* ----------------------------------------------------------- *
    *  "-b" enables the display with specific brightness          *
    * ----------------------------------------------------------- */
   if(argflag == 1) {
      tm1640_on(d1, brightness);  
      tm1640_destroy(d1);
      exit(0);
   }

   /* ----------------------------------------------------------- *
    *  "-e" empty (clear) the display content                     *
    * ----------------------------------------------------------- */
   if(argflag == 3) {
      tm1640_clear(d1);
      tm1640_destroy(d1);
      exit(0);
   }

   /* ----------------------------------------------------------- *
    *  "-o" turns the display off                                 *
    * ----------------------------------------------------------- */
   if(argflag == 4) {
      tm1640_off(d1);  
      tm1640_destroy(d1);
      exit(0);
   }
   /* ----------------------------------------------------------- *
    *  "-w"  writes the string of digits to thje display          *
    * ----------------------------------------------------------- */
   if(argflag == 2) {
      int result = tm1640_write(d1, 0, digits, strlen(digits), inverted);
      if (result != 0) {
         fprintf(stderr, "%s: error %d\n", argv[0], result);
         exit(-1);
      }
   }
   tm1640_destroy(d1);
   exit (0);
}
