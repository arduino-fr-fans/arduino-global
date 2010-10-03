#include <avr/pgmspace.h>
#include "pins.h"
#include "letters.h"

extern Buffer* letter_set_to_buf(Buffer* buf, const prog_uchar* pattern) {
  char i, cpt;
  
  cpt=0;
  for(i=LEDMATRIX_COLS-1; i>=0; i--)
    buf->content[cpt++] = pgm_read_byte_near(pattern + i);
    
  return buf;
}
