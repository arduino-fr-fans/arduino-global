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
  //Serial.begin(9600);

  for(int i=0; i<3; i++) {
    pinMode(row[i], OUTPUT);
    pinMode(col[i], OUTPUT);
    digitalWrite(col[i], HIGH);
  }

  for(int x=0; x<3; x++){
    for(int y=0; y<3; y++) {
      pixels[x][y] = HIGH;
    }
  }
}

void loop()                     
{
  char cprev;
  char rprev;

refreshScreen();
for(int r=0; r<3; r++) {
    for(int c=0; c<3; c++) {
      on(r, c);
      cprev = c;
      rprev = r;
      refreshScreen();
      delay(400);
      off(rprev, cprev);
      refreshScreen();
    }
  }
}

void on(char r, char c) {
  pixels[r][c] = LOW;
}

void off(char r, char c) {
  pixels[r][c] = HIGH;
}

void refreshScreen() {
  lighton=false;
  for(int r=0; r<3; r++) {
    digitalWrite(row[r], LOW);

    for (int c=0; c<3; c++) {
      char p = pixels[r][c];
      if(!lighton)
        digitalWrite(col[c], p);

      // if set to on
      if (p == LOW) {
        digitalWrite(row[r], HIGH);
	lighton=true;
      }
    }
  }
}

