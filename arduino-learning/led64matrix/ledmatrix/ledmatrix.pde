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


  Buffer buf, buf2;

  void setup() {
    Serial.begin(9600);
    setupPins();
    
    buffer_init(&buf);
    buffer_init(&buf2);
    buffer_invert(&buf2);
    buffer_addCircle(&buf, 4, 4, 3);
    buffer_addPixel(&buf, 3, 5);
    buffer_addPixel(&buf, 5, 5);
    buffer_addLine(&buf, 3, 3, 5, 3);
    buffer_translate(&buf, -1, -1);
    
    setDisplay(true);
  }
  
  
/*******************************  
 **********   DEMOS   **********
 *******************************/
  
  void demo_smiley() {
    unsigned char pos;
    char way[4][2] = {
      {1,0},
      {0,1},
      {-1,0},
      {0,-1}
    };
    
    while (1) {
      buffer_draw_with_duration(&buf, 50);
      buffer_translate(&buf, way[pos][0], way[pos][1]);
      pos = (pos+1) % 4;
    } // while
  }
  
  void demo_scrolling() {
    byte bigb[128];
    byte* currentb;
    Buffer b;
    
    b.length = LEDMATRIX_COLS;
    currentb = bigb;
    
    // Initialisation of bigb
    for(int i=0; i<128; i++)
      bigb[i] = buf.content[i%8];
    
    for(int i=0; i<120; i++) {
      buffer_draw_with_duration(&b, 70);
      
      // Copy new buffer
      for(int j=0; j<8; j++)
        b.content[j] = bigb[i+j];
    }
  }
  
/*******************************  
 ********** Main loop **********
 *******************************/
 
  void loop() {
    //demo_smiley();
    demo_scrolling();
  }
}

