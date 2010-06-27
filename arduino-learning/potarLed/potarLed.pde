void setup(){
  pinMode (13, OUTPUT);
  pinMode (1, INPUT);
  
  
  digitalWrite (3, HIGH); 
}

void loop() {
  
  int potar = analogRead(1) ;
  int mappedValue = map (potar, 0, 1023, 0, 255);
  
  analogWrite (3, mappedValue);
  
}
