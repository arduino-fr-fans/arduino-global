#include "led-wall.h"

const char col[3] = {
  11,12,13 };
const char row[3] = {
  10,9,8 };

char pixels[3][3];
char donottouch[3][3];
char x=0;
char y=0;
boolean lighton=false;

void setup()   {                
  int i,x,y;
  //Serial.begin(9600);

  for(i=0; i<3; i++) {
    pinMode(row[i], OUTPUT);
    pinMode(col[i], OUTPUT);
    digitalWrite(col[i], HIGH);
  }

  for(x=0; x<3; x++){
    for(y=0; y<3; y++) {
      pixels[x][y] = HIGH;
    }
  }
}

void loop()                     
{
  display(0,0);
  display(0,1);
  display(0,2);
  display(1,0);
  display(1,1);
  display(1,2);
  display(2,0);
  display(2,1);
  display(2,2);
}

void display(char r, char c) {
  on(r,c);
  delay(1);
  off(r,c);
}

void on(char r, char c) {
  digitalWrite(row[r], HIGH);
  digitalWrite(col[c], LOW);
}

void off(char r, char c) {
  digitalWrite(row[r], LOW);
  digitalWrite(col[c], HIGH);
}

