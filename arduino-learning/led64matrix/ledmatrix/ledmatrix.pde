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
  
  #define SCROLL_BUFFFER_SIZE (LEDMATRIX_COLS*2)


  Buffer buf, buf2;
  byte content[SCROLL_BUFFFER_SIZE];

  void setup() {
    Serial.begin(9600);
    setupPins();
    
    buffer_init(&buf);
    buffer_addCircle(&buf, 4, 4, 3);
    buffer_addPixel(&buf, 3, 5);
    buffer_addPixel(&buf, 5, 5);
    buffer_addLine(&buf, 3, 3, 5, 3);
    buffer_translate(&buf, -1, -1);
    
    buf2.length=LEDMATRIX_COLS;
    buf2.content=content;
    for(int i=0; i<SCROLL_BUFFFER_SIZE; i++) {
      buf2.content[i] = buf.content[i%8];
    }
    
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
      buffer_draw_with_duration(&buf, 100);
      buffer_translate(&buf, way[pos][0], way[pos][1]);
      pos = (pos+1) % 4;
    } // while
  }

  char cpt=0;
  void demo_scrolling() {
    buffer_draw_with_duration(&buf2, 150);
    buf2.content++;
    cpt++;
    
    if(cpt == SCROLL_BUFFFER_SIZE - LEDMATRIX_COLS) {
      cpt=0;
      buf2.content=content;
    }
  }

  
/*******************************  
 ********** Main loop **********
 *******************************/
 
  void loop() {
    //demo_smiley();
    demo_scrolling();
    //buffer_draw_with_duration(&buf2, 150);
  }
}

