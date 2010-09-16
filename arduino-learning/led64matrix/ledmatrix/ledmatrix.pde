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


  #define TIME 100
  long previousMillis = 0;
  long interval = TIME; 
  unsigned long currentMillis;
  unsigned char cpt = 0;
  
  #define NB_LINES 4
  uchar pat1[NB_LINES][4] = {
    {2,1,2,3},
    {1,1,3,3},
    {1,2,3,2},
    {3,1,1,3}
  };
  Buffer buffers1[NB_LINES];
  Buffer buffers2[NB_LINES];
  Buffer buffers3[NB_LINES];
  Buffer buffers4[NB_LINES];

  void setup() {
    Serial.begin(9600);
    setupPins();
    
    for (int i=0; i<NB_LINES; i++) {
      buffer_init(&buffers1[i]);
      buffer_init(&buffers2[i]);
      buffer_init(&buffers3[i]);
      buffer_init(&buffers4[i]);
      
      buffer_addLine(&buffers1[i], pat1[i][0], pat1[i][1], pat1[i][2], pat1[i][3]);

      buffer_cpy(&buffers1[i], &buffers2[i]);
      buffer_translate(&buffers2[i], 1, 1);
      
      buffer_cpy(&buffers2[i], &buffers3[i]);
      buffer_translate(&buffers3[i], -3, 0);
      
   /*   buffer_cpy(&buffers1[i], &buffers3[i]);
      buffer_translate(&buffers3[i], 3, 0);
      
      buffer_cpy(&buffers1[i], &buffers4[i]);
      buffer_translate(&buffers4[i], 0, 3);*/
    }
    
    setDisplay(true);
  }
  
  void loop() {
/*    buffer_draw(&buffers1[cpt]);
    buffer_draw(&buffers2[cpt]);
    buffer_draw(&buffers3[cpt]);*/
    buffer_draw(&buffers2[cpt]);
    
    currentMillis = millis();
    if(currentMillis - previousMillis > interval) {
      previousMillis = currentMillis;
      cpt = (cpt+1) % NB_LINES;
    }
  }
}
