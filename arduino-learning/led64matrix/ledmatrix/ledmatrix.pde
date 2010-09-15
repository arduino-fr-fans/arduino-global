/**
  * Code corresponding to ledmatrix_8x8.fz
  * COLS are controled by a 74HC238 3 bits multiplexer
  * ROWS are controled by a 74HC595 8 bits shift register
  * Author : Nicolas Maupu
  */
extern "C" {
  #include "utils.h"
  #include "pins.h"
  #include "geom.h"


  #define TIME 50
  long previousMillis = 0;
  long interval = TIME; 
  unsigned long currentMillis;
  unsigned char cpt = 0;
  
  #define NB_LINES 4
  uchar lines[NB_LINES][4] = {
    {4,0,4,7},
    {0,0,7,7},
    {0,4,7,4},
    {7,0,0,7},
  };
  Buffer buffers[NB_LINES];

  void setup() {
    Serial.begin(9600);
    setupPins();
    
    for (int i=0; i<NB_LINES; i++) {
      buffer_init(&buffers[i]);
      buffer_addLine(&buffers[i], lines[i][0], lines[i][1], lines[i][2], lines[i][3]);
    }
    
    setDisplay(true);
  }
  
  void loop() {
    buffer_draw(&buffers[cpt]);
    
    currentMillis = millis();
    if(currentMillis - previousMillis > interval) {
      previousMillis = currentMillis;
      cpt = (cpt+1) % NB_LINES;
    }
  }
}
