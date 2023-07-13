#include "cursor.h"
#include "vbe.h"
#include "xpm/xpm.h"

cursor_t *create_cursor(int x, int y) {
  cursor_t *cursor = malloc(sizeof(cursor_t));

  cursor->x = x;
  cursor->y = y;

  return cursor;
}

void delete_cursor(cursor_t *cursor) {
  free(cursor);
}

void draw_cursor(cursor_t *cursor) {
  xpm_image_t img;

  xpm_load(two_points_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, cursor->x, cursor->y);
}

void move_cursor(cursor_t *cursor, int difx, int dify) {
  cursor->x += difx;

  if (cursor->x < 0)
    cursor->x = 0;

  if (cursor->x > 1024)
    cursor->x = 1024;

  cursor->y -= dify;

  if (cursor->y < 0)
    cursor->y = 0;

  if (cursor->y > 768)
    cursor->y = 768;
}
