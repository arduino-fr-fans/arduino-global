#ifndef __GEOM_HEADER__
#define __GEOM_HEADER__
#include "pins.h"

struct _Buffer {
  byte content[LEDMATRIX_COLS];
  unsigned char length;
};


typedef unsigned char uchar;
typedef struct _Buffer Buffer;

extern void drawPixel(uchar, uchar);
extern void drawLine(uchar, uchar, uchar, uchar);

/** 
 * Buffer
 */
extern void buffer_init(Buffer*);
extern void buffer_addPixel(Buffer*, uchar, uchar);
extern void buffer_addLine(Buffer*, uchar, uchar, uchar, uchar);
extern void buffer_draw(const Buffer*);
#endif
