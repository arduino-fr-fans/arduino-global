#include <WProgram.h>
#include "pins.h"

void setupPins() {
  int i;

  /**
   * 74HC238
   */
  pinMode(MUX_A, OUTPUT);
  pinMode(MUX_B, OUTPUT);
  pinMode(MUX_C, OUTPUT);
  
  pinMode(MUX_G1,  OUTPUT);
  digitalWrite(MUX_G1,  LOW);
  
  /**
   * 74HC595
   */
  pinMode(LATCH_PIN, OUTPUT);
  pinMode(CLOCK_PIN, OUTPUT);
  pinMode(DATA_PIN, OUTPUT);
  // Set all pins to true to set all leds off
  sendToShiftRegister(0);
}

void sendToShiftRegister(byte value) {
  digitalWrite(LATCH_PIN, LOW);
  shiftOut(DATA_PIN, CLOCK_PIN, LSBFIRST, CAD(value));
  digitalWrite(LATCH_PIN, HIGH);
}

void setColHigh(unsigned char c) {
  unsigned char offset = MUX_OUT_0;
  
  switch (c) {
    case 0:
      offset = MUX_OUT_0;
      break;
    case 1:
      offset = MUX_OUT_1;
      break;
    case 2:
      offset = MUX_OUT_2;
      break;
    case 3:
      offset = MUX_OUT_3;
      break;
    case 4:
      offset = MUX_OUT_4;
      break;
    case 5:
      offset = MUX_OUT_5;
      break;
    case 6:
      offset = MUX_OUT_6;
      break;
    case 7:
      offset = MUX_OUT_7;
      break;
  }
  
  digitalWrite(MUX_A, MUX_GET_A(offset));
  digitalWrite(MUX_B, MUX_GET_B(offset));
  digitalWrite(MUX_C, MUX_GET_C(offset));
}

