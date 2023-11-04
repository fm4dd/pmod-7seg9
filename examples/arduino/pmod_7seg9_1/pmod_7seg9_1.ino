
// pmod_7seg9_1.ino
//
// This program tests the pmod-7seg9 module
// connected to PMOD2RPI PMOD1 port, lower
// pin row. The code is based on the TM1638
// library code by Ricardo Batista, located
// https://github.com/rjbatista/tm1638-library/
//
// PMOD1 XIAO pin assignment:
// -----------------------------------------
// pmod1-5 = XIAO gpio D3  NC
// pmod1-6 = XIAO gpio D2  NC
// pmod1-7 = XIAO gpio D5  tm_din
// pmod1-8 = XIAO gpio D4  tm_clk
// -----------------------------------------
// Note:
// 1 PMOD2RPI switch SW3-1 in "ON" position
// The pmod power draw can be too high for
// some MCU, including the Seeedstudio XAIO 
// -----------------------------------------
#include "TM1640.h"

// params: dataPin, clockPin, activateDisplay (true/false), intensity (0..7)
TM1640 module(5, 4, true, 2);
// we can instantiate the module with activate and intensity default values,
// using only data and clock Pin, later use module.setupDisplay() to control.
//TM1640 module(5, 4);

void setup() {
  module.clearDisplay();
  // module.setupDisplay(true, 1);
  module.setDisplayToString("123454321");
}

void loop(){}