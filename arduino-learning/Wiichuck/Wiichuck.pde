// Controlling a servo position using a potentiometer (variable resistor) 
// by Michal Rinott <http://people.interaction-ivrea.it/m.rinott> 

#include <Servo.h> 
#include <Wire.h> 
#include "nunchuck_funcs.h"

Servo myservo;  // create servo object to control a servo 

int potpin = 0;  // analog pin used to connect the potentiometer
int val;    // variable to read the value from the analog pin 
byte accx,accy,zbut,cbut;



void setup() 
{ 
  Serial.begin(19200);
  nunchuck_setpowerpins();
  nunchuck_init(); // send the initilization handshake
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
} 

void loop() 
{ 

  delay(100);
  nunchuck_get_data();

  accx  = nunchuck_accelx(); // ranges from approx 70 - 182
  accy  = nunchuck_accely(); // ranges from approx 65 - 173
  zbut = nunchuck_zbutton();
  cbut = nunchuck_cbutton(); 

  Serial.print("accx: "); Serial.print((byte)accx,DEC);
  Serial.print("\taccy: "); Serial.print((byte)accy,DEC);
  Serial.print("\tzbut: "); Serial.print((byte)zbut,DEC);
  Serial.print("\tcbut: "); Serial.println((byte)cbut,DEC);
    
  digitalWrite(13, zbut);
//  accy = map(accy, 65, 173, 10, 169);     // scale it to use it with the servo (value between 0 and 180) 
  
  myservo.write(accy);                  // sets the servo position according to the scaled value 
  delay(15);                           // waits for the servo to get there 

} 

