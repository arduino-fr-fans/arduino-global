#include <WProgram.h>
#include "pins.h"
#include "utils.h"
#include "geom.h"

extern Buffer* buffer_init(Buffer* buf) {
  char i;
  
  buf->length = LEDMATRIX_COLS;
  
  for(i=0; i<buf->length; i++)
    buf->content[i] = 0;
    
  return buf;
}

extern Buffer* buffer_addPixel(Buffer* buf, uint x, uint y) {
  buf->content[x] |= 1<<y;
  return buf;
}

/**
 * Thanks to Bresenham !
 */
extern Buffer* buffer_addLine(Buffer* buf, uint x1, uint y1, uint x2, uint y2) {
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
  
  return buf;
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

extern Buffer* buffer_translate(Buffer* buf, int x, int y) {
  char i;
  Buffer buf2;
  
  if (y != 0) {
    for(i=0; i<buf->length; i++) {
      if ( y > 0 )
        buf->content[i] <<= y;
      else
        buf->content[i] >>= abs(y);
    }
  }
  
  if ( x != 0 ) {
    // Copy and drop primary buf
    buffer_cpy(buf, &buf2);
    buffer_init(buf);
    
    int beg = x>0 ? 0 : abs(x);
    int end = x>0 ? buf2.length-x : buf2.length;
    for (i=beg; i<end; i++)
      buf->content[i+x] = buf2.content[i];
  }
  
  return buf;
}
extern Buffer* buffer_cpy(const Buffer* src, Buffer* dst) {
  char i;
  buffer_init(dst);
  for(i=0; i<src->length; i++)
    dst->content[i] = src->content[i];
  
  return dst;
}

/**
 * Bresenham rocks ! (and wikipedia too)
 */
extern Buffer* buffer_addCircle(Buffer* buf, uint cx, uint cy, uint radius)
{
  int error = -radius;
  int x = radius;
  int y = 0;
 
  while (x >= y) {
    _plot8points(buf, cx, cy, x, y);
    
    error += y;
    ++y;
    error += y;
    
    if (error >= 0) {
      --x;
      error -= x;
      error -= x;
    }
  }
  
  return buf;
}
 
void _plot8points(Buffer* buf, uint cx, uint cy, int x, int y) {
  _plot4points(buf, cx, cy, x, y);
  if (x != y)
    _plot4points(buf, cx, cy, y, x);
}

void _plot4points(Buffer* buf, uint cx, uint cy, int x, int y) {
  buffer_addPixel(buf, cx + x, cy + y);

  if (x != 0)
    buffer_addPixel(buf, cx - x, cy + y);
  if (y != 0)
    buffer_addPixel(buf, cx + x, cy - y);
  if (x != 0 && y != 0)
    buffer_addPixel(buf, cx - x, cy - y);
}
