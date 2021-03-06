#ifndef __GEOM_HEADER__
#define __GEOM_HEADER__
#include "pins.h"

typedef unsigned char uchar;
typedef unsigned int uint;
typedef struct _Buffer Buffer;

struct _Buffer {
  // Buffer content
  byte* content;
  // Buffer content begining
  byte* content_beg;
  // Buffer total length
  uchar length;
  // Buffer content length left
  uchar length_left;
  // Display width (by default = LEDMATRIX_COLS = 8)
  uchar display_width;
};

#define LEFT 0
#define RIGHT 1
#define UP 2
#define DOWN 3

/** 
 * Buffer
 */
extern Buffer* buffer_init(Buffer*);
extern Buffer* buffer_init_with_length(Buffer*, uchar);
extern Buffer* buffer_reinit(Buffer*);
extern Buffer* buffer_destroy(Buffer*);
extern Buffer* buffer_reset(Buffer*);
extern Buffer* buffer_addPixel(Buffer*, uint, uint);
extern Buffer* buffer_addLine(Buffer*, uint, uint, uint, uint);
extern void buffer_draw(const Buffer*);
extern void buffer_draw_with_duration(const Buffer*, uint);
extern void buffer_draw_col(const Buffer*, uint);
extern Buffer* buffer_translate(Buffer*, int, int);
extern Buffer* buffer_set_content(Buffer*, const byte*, uchar);
extern boolean buffer_scroll(Buffer*, uchar);
extern Buffer* buffer_invert(Buffer*);
extern Buffer* buffer_cpy(const Buffer*, Buffer*);
extern Buffer* buffer_addCircle(Buffer* buf, uint, uint, uint);
extern Buffer* buffer_assemble(Buffer*, const Buffer*, const Buffer*);
extern Buffer* buffer_add(Buffer*, const Buffer*);
#endif

