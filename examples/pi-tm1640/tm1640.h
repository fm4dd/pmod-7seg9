/* ------------------------------------------------------------ *
 * file:        tm1640.h                                        *
 * purpose:     header file for settm1640.c & i2c_tm1640.c      *
 *                                                              *
 * author:      09/04/2021 Frank4DD                             *
 * ------------------------------------------------------------ */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <gpiod.h>

#define DISPLAYSTR 9         // max display size PMDO-7SEG9=9

/* ------------------------------------------------------- */
/* Define byte-as-bits printing for debug output           */
/* ------------------------------------------------------- */
#define BYTE_TO_BINARY_PATTERN "%c%c%c%c%c%c%c%c"
#define BYTE_TO_BINARY(byte)  \
  (byte & 0x80 ? '1' : '0'), \
  (byte & 0x40 ? '1' : '0'), \
  (byte & 0x20 ? '1' : '0'), \
  (byte & 0x10 ? '1' : '0'), \
  (byte & 0x08 ? '1' : '0'), \
  (byte & 0x04 ? '1' : '0'), \
  (byte & 0x02 ? '1' : '0'), \
  (byte & 0x01 ? '1' : '0') 

/* ------------------------------------------------------- */
/* Set gpiod interface circuit and consumer name           */
/* ------------------------------------------------------- */
#define CHIPNAME "gpiochip0"
#define PMOD     "pmod1"

typedef struct {
   struct gpiod_line *clockLine;
   struct gpiod_line *dataLine;
} tm1640_display;

/* ------------------------------------------------------- */
/* function definition                                     */
/* ------------------------------------------------------- */
tm1640_display* tm1640_init(unsigned int clockPin, unsigned int dataPin);
void tm1640_on(tm1640_display* display, char brightness);
int  tm1640_write(tm1640_display* display, int offset, char *string, char length, int invertMode);
void tm1640_off(tm1640_display* display);
void tm1640_destroy(tm1640_display* display);
char tm1640_vertical(char input);
void tm1640_setColon(tm1640_display* display, int num, int state);
void tm1640_setDegree(tm1640_display* display, int num, int state);
char tm1640_asc_to_7seg(char ascii);
void tm1640_clear(tm1640_display* display);
void tm1640_send(tm1640_display* display, char cmd, char * data, int len);
void tm1640_sendRaw(tm1640_display* display, char out);
void tm1640_sendCmd(tm1640_display* display, char cmd);
