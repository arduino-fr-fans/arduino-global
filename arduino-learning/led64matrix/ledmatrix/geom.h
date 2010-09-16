#ifndef __GEOM_HEADER__
#define __GEOM_HEADER__
#include "pins.h"

struct _Buffer {
  byte content[LEDMATRIX_COLS];
  unsigned char length;
};


typedef unsigned char uchar;
typedef unsigned int uint;
typedef struct _Buffer Buffer;

/** 
 * Buffer
 */
extern Buffer* buffer_init(Buffer*);
extern Buffer* buffer_addPixel(Buffer*, uint, uint);
extern Buffer* buffer_addLine(Buffer*, uint, uint, uint, uint);
extern void buffer_draw(const Buffer*);
extern Buffer* buffer_translate(Buffer*, int, int);
extern Buffer* buffer_cpy(const Buffer*, Buffer*);
extern Buffer* buffer_addCircle(Buffer* buf, uint, uint, uint);
#endif
