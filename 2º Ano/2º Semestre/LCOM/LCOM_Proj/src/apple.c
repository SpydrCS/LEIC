#include "apple.h"
#include "vbe.h"
#include "xpm/xpm.h"

static uint16_t x_i = 50, x_f = 974, y_i = 150, y_f = 700;

apple_t *create_apple() {
  apple_t *apple = malloc(sizeof(apple_t));
  srand(time(0));
  int appleX = rand() % (x_f - apple_default_size - 20);
  int appleY = rand() % (y_f - apple_default_size - 20);

  if (appleX < x_i)
    appleX += x_i + apple_default_size + 20;
  if (appleY < y_i)
    appleY += y_i + apple_default_size + 20;

  apple->x = appleX;
  apple->y = appleY;
  apple->size = apple_default_size;
  apple->color = 2;

  return apple;
}

void destroy_apple(apple_t *apple) {
  vg_draw_rectangle(apple->x, apple->y, apple->size, apple->size, 0);
  free(apple);
  return;
}

void draw_apple(apple_t *apple) {

  xpm_image_t img;
  xpm_load(apple_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, apple->x, apple->y);
  return;
}
