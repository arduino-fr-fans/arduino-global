#include <WProgram.h>
#include "pins.h"
#include "utils.h"
#include "geom.h"

extern Buffer* buffer_init(Buffer* buf) {
  return buffer_init_with_length(buf, LEDMATRIX_COLS);
}

extern Buffer* buffer_init_with_length(Buffer* buf, uchar length) {
  buf->length = length;
  buf->length_left = buf->length;
  buf->display_width=LEDMATRIX_COLS;
  buf->content_beg = (byte*)malloc(length*sizeof(byte));
  buf->content = buf->content_beg;
  
  return buf;
}

extern Buffer* buffer_destroy(Buffer* buf) {
  free (buf->content_beg);
  buf->length=0;
  buf->length_left=0;
  
  return buf;
}

/**
 * Reinitialize a buffer to begining
 */
extern Buffer* buffer_reinit(Buffer* buf) {
  buf->length_left = buf->length;
  buf->content = buf->content_beg;
}

extern Buffer* buffer_reset(Buffer* buf) {
  uchar i;
  
  for(i=0; i<buf->length; i++)
    buf->content_beg[i] = 0;
    
  return buf;
}

extern Buffer* buffer_addPixel(Buffer* buf, uint x, uint y) {
  buf->content_beg[x] |= 1<<y;
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
  buffer_draw_with_duration(buf, 0);
}

extern void buffer_draw_with_duration(const Buffer* buf, uint duration) {
  uchar i;
  unsigned long currentMillis = millis();
  unsigned long initialMillis = currentMillis;
  
  // Display until we reach 'duration' milliseconds
  while (currentMillis - initialMillis <= duration) {
    // Display once
    for (i=0; i<buf->display_width; i++) {
      buffer_draw_col(buf, i);
      // delay 0 avoid flickering and provide a better light - before arduino release 0019 ;-)
      delay(1);
    } // for
    
    currentMillis = millis();
  } // while
}

extern void buffer_draw_col(const Buffer* buf, uint col) {
  setDisplay(false);
  setColHigh(col);
  sendToShiftRegister(buf->content[col]);
  setDisplay(true);
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
        buf->content_beg[i] <<= y;
      else
        buf->content_beg[i] >>= abs(y);
    }
  }
  
  if ( x != 0 ) {
    // Copy and drop primary buf
    buffer_init_with_length(&buf2, buf->length);
    buffer_cpy(buf, &buf2);
    buffer_reset(buf);
    
    int beg = x>0 ? 0 : abs(x);
    int end = x>0 ? buf2.length-x : buf2.length;
    for (i=beg; i<end; i++)
      buf->content_beg[i+x] = buf2.content_beg[i];
  }
  
  return buf;
}

/**
 * Set content of a buffer
 * Nothing beeing freed !
 */
extern Buffer* buffer_set_content(Buffer* buf, const byte* content, uchar length) {
  buffer_destroy(buf);
  buf->content = content;
  buf->content_beg = buf->content;
  buf->length  = length;
  buf->length_left = length;
}

/**
 * Scroll buffer content by one on LEFT or RIGHT direction
 */
extern boolean buffer_scroll(Buffer* buf, uchar dir) {
  boolean ret=true;
  
  switch(dir) {
    case LEFT:
      if ( (ret = buf->length_left > buf->display_width) ) {
        buf->content++;
        buf->length_left--;
      }
      break;
    case RIGHT:
      if( (ret = buf->length_left < buf->length) ) {
        buf->content--;
        buf->length_left++;
      }
      break;
    default:
      ret=false;
  }
  
  return ret;
}

extern Buffer* buffer_invert(Buffer* buf) {
  /* Invert buffer. Each 0 is transformed in 1 and vice versa */
  char i;
  for(i=0; i<buf->length; i++)
    buf->content_beg[i] = ~buf->content_beg[i];
  
  return buf;
}

extern Buffer* buffer_cpy(const Buffer* src, Buffer* dst) {
  char i;
  
  for(i=0; i<src->length; i++)
    dst->content_beg[i] = src->content_beg[i];
  
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

/**
 * Assemble Buf1 and Buf2 into dst buffer
 * dst must be a *valid buffer*, but *should not be initialized*
 */
extern Buffer* buffer_assemble(Buffer* dst, const Buffer* buf1, const Buffer* buf2) {
  byte* old_content;
  
  buffer_init_with_length(dst, buf1->length+buf2->length);
  
  /* Copy first buffer */
  buffer_cpy(buf1, dst);
  
  /* Copy second buffer */
  // Backup 
  old_content = dst->content_beg;
  dst->content_beg += buf1->length;
  buffer_cpy(buf2, dst);
  // Restore content
  dst->content_beg = old_content;
  
  return dst;
}
