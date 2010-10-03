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
  
  Buffer buf1, buf2, buf3;

  void setup() {
    Serial.begin(9600);
    setupPins();
    
    buffer_init(&buf1);
    buffer_reset(&buf1);
    buffer_addCircle(&buf1, 4, 4, 3);
    buffer_addPixel(&buf1, 3, 5);
    buffer_addPixel(&buf1, 5, 5);
    buffer_addLine(&buf1, 3, 3, 5, 3);
    buffer_translate(&buf1, -1, -1);
    
    // Make buf2 as long as double buf1
    buffer_init(&buf2);
    buffer_cpy(&buf1, &buf2);
    buffer_translate(&buf2, 1, 1);
    buffer_assemble(&buf3, &buf1, &buf2);
    
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
      buffer_draw_with_duration(&buf1, 100);
      buffer_translate(&buf1, way[pos][0], way[pos][1]);
      pos = (pos+1) % 4;
    } // while
  }

  uchar dir = LEFT;
  void demo_scrolling() {
    buffer_draw_with_duration(&buf3, 150);
    if( !buffer_scroll(&buf3, dir) ) {
      dir = (dir == LEFT) ? RIGHT : LEFT;
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

