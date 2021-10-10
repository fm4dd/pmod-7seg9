## Pi-TM1640

Linux 'C' Control Code for designs based on the Titan Micro LED Driver IC TM1640.
Implemented and tested on a Raspberry Pi, using the PMOD2RPI interface board and a PMOD-7SEG9 module. 

The code defaults the clock/data pins to GPIO 18/26 located on PMOD1 lower row.
Calling the control program with -c/-d arguments sets the pins to other values.
To operate the PMOD-7SEG9 module on PMOD2 lower row, use ./settm1640 -c 24 -d 23.

### Prerequisites

```
pi@pi-ms05:~ $ sudo apt install libgpiod-dev
```

### Compilation


```
pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ make
gcc -O3 -Wall -g   -c -o tm1640.o tm1640.c
gcc -O3 -Wall -g   -c -o settm1640.o settm1640.c
gcc tm1640.o settm1640.o -o settm1640 -lgpiod
```

### Usage
```
pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ ./settm1640
Usage: settm1640 [-c <clockpin>] [-d <datapin>] -b <brightness>
       settm1640 [-c <clockpin>] [-d <datapin>] [-i] -o <display-digits> [-a <l|r>]
       settm1640 [-c <clockpin>] [-d <datapin>] -e
       settm1640 [-c <clockpin>] [-d <datapin>] -o

Command line parameters have the following format:
   -a   left/right alignment either 'l' or 'r' (default)
   -b   enable display with LED brightness 0..7
        example: -b 5
   -c   clock pin GPIO number
   -d   data pin GPIO number
   -e   empty (clear) the display
   -i   vertical inverted (together with -w)
   -o   display off switch
   -w   1..9-digit output string to display
        example: -o 12345678
   -h   display this message
   -v   enable debug output


Usage examples:
./settm1640 -c 18 -d 26 -b 2
./settm1640 -c 18 -d 26 -e
./settm1640 -c 18 -d 26 -o
./settm1640 -c 18 -d 26 -w 876543210
```

### Examples

Enable the 7-Seg display connected to PMOD2RPI PMOD1 (lower row), with verbose on:
```
pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ ./settm1640 -v -b 4
Debug: arg -b, value 4
Debug: ts=[1633842468] date=Sun Oct 10 14:07:48 2021
Debug: tm1640_init(c=18, d=26)
Debug: tm1640_sendCmd(0x8C)
  Debug: tm1640_sendRaw(0x8C) 10001100 ...complete
...Cmd done
Debug: tm1640_on(4) complete
```

Write the string "9.87654" to the 7-Seg display on PMOD2RPI PMOD1 (lower row), with verbose on:
```
pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ ./settm1640 -v -w 9.87654
Debug: arg -w, value 9.87654
Debug: ts=[1633842358] date=Sun Oct 10 14:05:58 2021
Debug: tm1640_init(c=18, d=26)
Debug: tm1640_write(s=9.87654 l=7 i=0):
  Debug: char 9 = 01101111
  Debug: char . = 10000000
  Debug: char 8 = 01111111
  Debug: char 7 = 00100111
  Debug: char 6 = 01111101
  Debug: char 5 = 01101101
  Debug: char 4 = 01100110
Debug: tm1640_sendCmd(0x44)
  Debug: tm1640_sendRaw(0x44) 01000100 ...complete
...Cmd done
  Debug: tm1640_sendRaw(0xC0) 11000000 ...complete
  Debug: tm1640_sendRaw(0xEF) 11101111 ...complete
  Debug: tm1640_sendRaw(0x7F) 01111111 ...complete
  Debug: tm1640_sendRaw(0x27) 00100111 ...complete
  Debug: tm1640_sendRaw(0x7D) 01111101 ...complete
  Debug: tm1640_sendRaw(0x6D) 01101101 ...complete
  Debug: tm1640_sendRaw(0x66) 01100110 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
...write done
```

Write the same string "9.87654" with verbose on, but with the output vertically inverted:
```
pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ ./settm1640 -v -w 9.87654 -i
Debug: arg -w, value 9.87654
Debug: arg -i
Debug: ts=[1633842391] date=Sun Oct 10 14:06:31 2021
Debug: tm1640_init(c=18, d=26)
Debug: tm1640_write(s=9.87654 l=7 i=1):
  Debug: invert 01100110 = 01110100
  Debug: char 4 = 01110100
  Debug: invert 01101101 = 01101101
  Debug: char 5 = 01101101
  Debug: invert 01111101 = 01101111
  Debug: char 6 = 01101111
  Debug: invert 00100111 = 00111100
  Debug: char 7 = 00111100
  Debug: invert 01111111 = 01111111
  Debug: char 8 = 01111111
  Debug: invert 10000000 = 10000000
  Debug: char . = 10000000
  Debug: invert 01101111 = 01111101
  Debug: char 9 = 01111101
Debug: tm1640_sendCmd(0x44)
  Debug: tm1640_sendRaw(0x44) 01000100 ...complete
...Cmd done
  Debug: tm1640_sendRaw(0xC0) 11000000 ...complete
  Debug: tm1640_sendRaw(0x74) 01110100 ...complete
  Debug: tm1640_sendRaw(0x6D) 01101101 ...complete
  Debug: tm1640_sendRaw(0x6F) 01101111 ...complete
  Debug: tm1640_sendRaw(0x3C) 00111100 ...complete
  Debug: tm1640_sendRaw(0xFF) 11111111 ...complete
  Debug: tm1640_sendRaw(0x7D) 01111101 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
...write done
```

Using the -e argument clears the display (writing 'null' bytes):
``` 
pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ ./settm1640 -v -e
Debug: arg -e
Debug: ts=[1633842773] date=Sun Oct 10 14:12:53 2021
Debug: tm1640_init(c=18, d=26)
  Debug: tm1640_sendRaw(0xC0) 11000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
```

We can turn the display off with -o. This keeps the previous content, and a turn-on restores the output:
```
pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ ./settm1640 -v -o
Debug: arg -o
Debug: ts=[1633842994] date=Sun Oct 10 14:16:34 2021
Debug: tm1640_init(c=18, d=26)
Debug: tm1640_sendCmd(0x80)
  Debug: tm1640_sendRaw(0x80) 10000000 ...complete
...Cmd done
Debug: tm1640_off() complete

pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ ./settm1640 -v -b 4
Debug: arg -b, value 4
Debug: ts=[1633842997] date=Sun Oct 10 14:16:37 2021
Debug: tm1640_init(c=18, d=26)
Debug: tm1640_sendCmd(0x8C)
  Debug: tm1640_sendRaw(0x8C) 10001100 ...complete
...Cmd done
Debug: tm1640_on(4) complete
```

Multiple 7-Segment PMODs can be controlled in parallel by specifying the clock/data pins:
```
pi@pi-ms05:~/pmod2rpi/pi-tm1640 $ ./settm1640 -v -c 24 -d 23 -w "  12.34567"
Debug: arg -c, value 24
Debug: arg -d, value 23
Debug: arg -w, value   12.34567
Debug: ts=[1633843283] date=Sun Oct 10 14:21:23 2021
Debug: tm1640_init(c=24, d=23)
Debug: tm1640_write(s=  12.34567 l=10 i=0):
  Debug: char   = 00000000
  Debug: char   = 00000000
  Debug: char 1 = 00000110
  Debug: char 2 = 01011011
  Debug: char . = 10000000
  Debug: char 3 = 01001111
  Debug: char 4 = 01100110
  Debug: char 5 = 01101101
  Debug: char 6 = 01111101
  Debug: char 7 = 00100111
Debug: tm1640_sendCmd(0x44)
  Debug: tm1640_sendRaw(0x44) 01000100 ...complete
...Cmd done
  Debug: tm1640_sendRaw(0xC0) 11000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x00) 00000000 ...complete
  Debug: tm1640_sendRaw(0x06) 00000110 ...complete
  Debug: tm1640_sendRaw(0xDB) 11011011 ...complete
  Debug: tm1640_sendRaw(0x4F) 01001111 ...complete
  Debug: tm1640_sendRaw(0x66) 01100110 ...complete
  Debug: tm1640_sendRaw(0x6D) 01101101 ...complete
  Debug: tm1640_sendRaw(0x7D) 01111101 ...complete
  Debug: tm1640_sendRaw(0x27) 00100111 ...complete
...write done
```

This example with 7seg9 PMODs connected to a Raspberry Pi via the PMOD2RPI interface board:
<img src="https://github.com/fm4dd/pmod-7seg9/raw/master/images/7seg9-pmod2rpi-double.png" width="640px">


