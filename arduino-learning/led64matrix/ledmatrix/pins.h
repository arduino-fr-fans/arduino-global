#ifndef __PINS_HEADER__
#define __PINS_HEADER__
#include <WProgram.h>
// Arduino pins definition

#define LEDMATRIX_ROWS 8
#define LEDMATRIX_COLS 8

/**
 * 74HC238 pins definition
 */
#define MUX_A   5
#define MUX_B   4
#define MUX_C   3
#define MUX_G1  2 // ANALOG IN 4

/**
 * 74HC238 outputs (3 bits)
 */
#define MUX_OUT_0 0b000
#define MUX_OUT_1 0b100
#define MUX_OUT_2 0b010
#define MUX_OUT_3 0b110
#define MUX_OUT_4 0b001
#define MUX_OUT_5 0b101
#define MUX_OUT_6 0b011
#define MUX_OUT_7 0b111

// Macro to access values A, B or C easily
#define MUX_GET_A(v) ((v)&0b100)
#define MUX_GET_B(v) ((v)&0b010)
#define MUX_GET_C(v) ((v)&0b001)

#define MUX_ACTIVATE(b) (digitalWrite(MUX_G1, (b) ? HIGH : LOW))

/********************
 * 74HC595 relative *
 ********************/
/*
Shift Register Wiring Schematic
 Q1 -|    |- VCC
 Q2 -|    |- Q0
 Q3 -|    |- DS
 Q4 -|    |- OE
 Q5 -|    |- ST_CP
 Q6 -|    |- SH_CP
 Q7 -|    |- MR
VSS -|    |- Q' 
 
Key:
Q0 - Q7: Parallel Out Pins
Q': Cascade Pin
DS: Serial Data In Pin
OE: Output Enable (Active Low)
ST_CP: Latch Pin
SH_CP: Clock Pin
MR: Master Reset  (Active Low)
*/

// ST_CP of 74HC595
#define LATCH_PIN 12
// SH_CP of 74HC595
#define CLOCK_PIN 8
// DS of 74HC595
#define DATA_PIN 13

void setupPins();
void sendToShiftRegister(byte);
void setColHigh(unsigned char);
#define CAD(a) (~(a))

#endif

