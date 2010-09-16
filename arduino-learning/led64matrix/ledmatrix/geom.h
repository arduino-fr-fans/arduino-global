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
extern Buffer* buffer_init(Buffer*);
extern Buffer* buffer_addPixel(Buffer*, uchar, uchar);
extern Buffer* buffer_addLine(Buffer*, uchar, uchar, uchar, uchar);
extern void buffer_draw(const Buffer*);
extern Buffer* buffer_translate(Buffer*, uchar, uchar);
extern Buffer* buffer_cpy(const Buffer*, Buffer*);
#endif
