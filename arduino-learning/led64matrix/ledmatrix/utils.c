#include <WProgram.h>
#include "pins.h"

extern void flush() {
  set_display(false);
  set_display(true);
}

extern void setDisplay(boolean b) {
  MUX_ACTIVATE(b);
}

/*
extern void display_matrix(unsigned char m[LEDMATRIX_ROWS][LEDMATRIX_COLS], unsigned long time) {
  int c,r;
  unsigned long previous_millis = millis();
  unsigned long current_millis = previous_millis;
  
  while (current_millis - previous_millis <= time) {
    current_millis = millis();
    
    for(c=0; c<LEDMATRIX_COLS; c++) {
      MUX_ACTIVATE (false);
      for(r=0; r<LEDMATRIX_ROWS; r++) {
        set_row(r, m[r][c]==1);
      }
      
      set_col_high(c);
      MUX_ACTIVATE (true);
      delay(1);
    }
  }
  
  MUX_ACTIVATE (false);
}
*/

