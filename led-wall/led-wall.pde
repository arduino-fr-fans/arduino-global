#include "led-wall.h"

const char col[3] = {
  11,12,13 };
const char row[3] = {
  10,9,8 };

char pixels[3][3];
char donottouch[3][3];
char x=0;
char y=0;
boolean mode=true;

void setup()   {                
  int i,x,y;
  Serial.begin(9600);

  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  digitalWrite(3, LOW);
  digitalWrite(4, LOW);

  for(i=0; i<3; i++) {
    pinMode(row[i], OUTPUT);
    pinMode(col[i], OUTPUT);
    digitalWrite(col[i], HIGH);
  }

  clear_matrix();
}

void loop()                     
{
  if (Serial.available() > 0) {
    char inByte = Serial.read();

    switch (inByte) {
      case 'a':
        clear_matrix();
        break;
      case '+':
        mode = true;
        break;
      case '-':
        mode = false;
	break;
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        int val = atoi(&inByte);
	pixels[val/3][val%3] = mode;
	break;
    }
  }

  for(int i=0; i<3; i++) {
    for(int j=0; j<3; j++) {
      if(pixels[i][j]) {
        display(i, j);
      }
    }
  }
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

void clear_matrix() {
  for (int i=0; i<9; i++)
    pixels[i/3][i%3] = false;
}

