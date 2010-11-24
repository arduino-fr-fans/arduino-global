#define IRLED 12

void setup() {
  Serial.begin(9600);
  pinMode(IRLED, OUTPUT);
}

void loop() {
  delay(4000);
  Serial.println("Sending signal");
  sendInfraredSignal();
}

void sendInfraredSignal() {
  for(int i=0; i<16; i++) { 
    digitalWrite(IRLED, HIGH);
    delayMicroseconds(11);
    digitalWrite(IRLED, LOW);
    delayMicroseconds(11);
   } 
   delayMicroseconds(7330); 
   for(int i=0; i<16; i++) { 
     digitalWrite(IRLED, HIGH);
     delayMicroseconds(11);
     digitalWrite(IRLED, LOW);
     delayMicroseconds(11);
   }
}

