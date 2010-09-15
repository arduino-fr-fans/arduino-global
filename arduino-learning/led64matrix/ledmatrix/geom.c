#include <WProgram.h>
#include "pins.h"
#include "utils.h"
#include "geom.h"

extern void buffer_init(Buffer* buf) {
  char i;
  
  buf->length = LEDMATRIX_COLS;
  
  for(i=0; i<buf->length; i++)
    buf->content[i] = 0;
}

extern void buffer_addPixel(Buffer* buf, uchar x, uchar y) {
  buf->content[x] |= 1<<y;
}

/**
 * Thanks to Bresenham !
 */
extern void buffer_addLine(Buffer* buf, uchar x1, uchar y1, uchar x2, uchar y2) {
  int dx,dy,e,ystep,y,x;
  boolean steep;
  
  steep = abs(y1-y2) > abs(x1-x2);
  if(steep) {
    _swap(&x1, &y1);
    _swap(&x2, &y2);
  }
  
  if (x1 > x2) {
    _swap(&x1, &x2);
    _swap(&y1, &y2);
  }
  
  dx = x2 - x1;
  dy = abs(y2 - y1);
  e = dx / 2;
  y = y1;
  
  ystep = y1 < y2 ? 1 : -1;
  for (x=x1; x<=x2; x++) {
    if (steep)
      buffer_addPixel(buf, y,x);
    else
      buffer_addPixel(buf, x,y);
    e -= dy;
    if (e < 0) {
      y += ystep;
      e += dx;
    }
  }
}

extern void buffer_draw(const Buffer* buf) {
  char i;
  for (i=0; i<buf->length; i++) {
    // if at least one pixel is on for this column
    if(buf->content[i] > 0) {
      setDisplay(false);
      sendToShiftRegister(buf->content[i]);
      setColHigh(i);
      setDisplay(true);
    }
  }
}

void _swap(uchar* v1, uchar* v2) {
  int c = *v2;
  *v2 = *v1;
  *v1 = c;
  /*
  // slow
  *v1 = (*v1) * (*v2);
  *v2 = (*v1) / (*v2);
  *v1 = (*v1) / (*v2);
  */
}
