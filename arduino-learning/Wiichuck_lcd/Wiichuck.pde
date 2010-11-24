// Controlling a servo position using a potentiometer (variable resistor) 
// by Michal Rinott <http://people.interaction-ivrea.it/m.rinott> 

#include <LiquidCrystal.h>
#include <Wire.h>
#include "nunchuck_funcs.h"


int potpin = 0;  // analog pin used to connect the potentiometer
int val;    // variable to read the value from the analog pin 
byte accx,accy,accz,zbut,cbut;


// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(11, 12,5, 4, 3, 2);


void setup() 
{ 
  lcd.begin(16, 2);
  nunchuck_setpowerpins();
  nunchuck_init(); // send the initilization handshake
  
} 

void loop() 
{ 

  delay(100);
  nunchuck_get_data();

  accx  = nunchuck_accelx(); // ranges from approx 70 - 182
  accy  = nunchuck_accely(); // ranges from approx 65 - 173
  accz  = nunchuck_accelz(); // ranges from approx 65 - 173
  zbut = nunchuck_zbutton();
  cbut = nunchuck_cbutton(); 

  lcd.setCursor(0, 0);  
  lcd.print("X:"); lcd.print(accx,DEC);
  lcd.setCursor(6, 0);    
  lcd.print("Y:"); lcd.print(accy,DEC);
  lcd.setCursor(0, 1);
  lcd.print("Z:"); lcd.print(accz,DEC);
  lcd.setCursor(12, 0);  
  lcd.print("bZ:"); lcd.print(zbut,DEC);  
  lcd.setCursor(12, 1);  
  lcd.print("bC:"); lcd.print(cbut,DEC);  
    

} 

