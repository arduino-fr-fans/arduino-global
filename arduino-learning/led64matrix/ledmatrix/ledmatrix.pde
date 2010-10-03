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
  #include "letters.h"
  
  Buffer smiley, buf1, buf2, buf3, buftest;

  void setup() {
    Serial.begin(9600);
    setupPins();
    
    buffer_init(&smiley);
    buffer_reset(&smiley);
    buffer_addCircle(&smiley, 4, 4, 3);
    buffer_addPixel(&smiley, 3, 5);
    buffer_addPixel(&smiley, 5, 5);
    buffer_addLine(&smiley, 3, 3, 5, 3);
    buffer_translate(&smiley, -1, -1);
    
    
    buffer_init(&buf1);
    buffer_init_with_length(&buf2, 1);
    buffer_init(&buf3);
    
    letter_set_to_buf(&buf1, PATTERN_F);
    buffer_add(&buf3, &buf1);
    
    buffer_add(&buf3, &buf2);
    
    letter_set_to_buf(&buf1, PATTERN_A);
    buffer_add(&buf3, &buf1);
    
    buffer_add(&buf3, &buf2);
    
    letter_set_to_buf(&buf1, PATTERN_I);
    buffer_add(&buf3, &buf1);
    
    buffer_add(&buf3, &buf2);
    
    letter_set_to_buf(&buf1, PATTERN_L);
    buffer_add(&buf3, &buf1);
    
    buffer_add(&buf3, &buf2);
    
    letter_set_to_buf(&buf1, PATTERN_EXCLAMATION);
    buffer_add(&buf3, &buf1);
    buffer_add(&buf3, &buf2);
    buffer_add(&buf3, &buf2);
    buffer_add(&buf3, &buf2);
    buffer_add(&buf3, &buf2);
    buffer_add(&buf3, &buf2);
    
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
      buffer_draw_with_duration(&smiley, 100);
      buffer_translate(&smiley, way[pos][0], way[pos][1]);
      pos = (pos+1) % 4;
    } // while
  }

  void demo_scrolling() {
    buffer_draw_with_duration(&buf3, 150);
    buffer_scroll(&buf3, LEFT);

    if (buf3.length_left <= buf3.display_width)
      buffer_reinit(&buf3);
  }

  
/*******************************  
 ********** Main loop **********
 *******************************/
 
  void loop() {
    //demo_smiley();
    demo_scrolling();
  }
}

