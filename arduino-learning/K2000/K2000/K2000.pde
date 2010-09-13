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


// Hex Character from 0 - F
byte hexArray[16] = 
{ 
  B10000000,
  B11111001,  // 1 = { 2, 3 }
  B10100100,  // 2 = { 1, 2, 4, 5, 7} 
  B10110000,  // 3 = { 1, 2, 3, 4, 7}
  B10011001,  // 4 = { 2, 3, 6, 7}
  B10010010,  // 5 = { 1, 3, 4, 6, 7}
  B10000010,  // 6 = { 1, 3, 4, 5, 6, 7}
  B11111000,  // 7 = { 1, 2, 3}
  B10000000,  // 8 = { 1, 2, 3, 4, 5, 6, 7}
  B10010000,  // 9 = { 1, 2, 3, 4, 6, 7}
  B10001000,  // A = { 1, 2, 3, 5, 6, 7}
  B10000000,  // B = { 1, 2, 3, 4, 5, 6, 7}
  B11000110,  // C = { 1, 4, 5, 6}
  B11000000,  // D = { 1, 2, 3, 4, 5, 6}
  B10000110,  // E = { 1, 4, 5, 6, 7}
  B10001110,  // F = { 1, 5, 6, 7} 
};


void setup() {
  Serial.begin(9600);
  pinMode(LATCH_PIN, OUTPUT);
  pinMode(CLOCK_PIN, OUTPUT);
  pinMode(DATA_PIN, OUTPUT);
}

void sendToShiftRegister(int pot) {
  digitalWrite(LATCH_PIN, LOW);
  //shiftOut(DATA_PIN, CLOCK_PIN, LSBFIRST, hexArray[pot]);
  shiftOut(DATA_PIN, CLOCK_PIN, LSBFIRST, B00000001);
  digitalWrite(LATCH_PIN, HIGH);
}

void shiftRegister(byte val) {
  digitalWrite(LATCH_PIN, LOW);
  shiftOut(DATA_PIN, CLOCK_PIN, LSBFIRST, val);
  digitalWrite(LATCH_PIN, HIGH);
}

int cpt = 1;
boolean down = true;
void loop() 
{
  if (cpt%128 == 0)
    down = false;
  if (cpt == 1)
    down = true;
  
  if (down) {
    cpt = (cpt<<1);
  } else {
    cpt = (cpt>>1);
  }
  
  shiftRegister(cpt);
  delay(70);
}
