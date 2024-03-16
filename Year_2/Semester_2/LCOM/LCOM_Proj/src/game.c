#include "game.h"
#include "xpm/xpm.h"
#include <lcom/lcf.h>

static uint16_t seconds_counter = 0;
static uint16_t x_i = 50, x_f = 974, y_i = 150, y_f = 700;

game_t *new_game() {
  game_t *game = malloc(sizeof(game_t));

  if (game == NULL)
    return NULL;
  game->apple = create_apple();
  game->snake = new_snake(2);
  game->points = 0;
  game->running = false;
  game->game_time = 0;

  return game;
}

void delete_game(game_t *game) {
  destroy_apple(game->apple);
  delete_snake(game->snake);
  free(game);
  return;
}

void reset_game(game_t *game) {
  delete_snake(game->snake);
  game->snake = new_snake(2);
  game->game_time = 0;
  game->points = 0;
  game->running = false;
  game->apple = create_apple();
}

void game_pause_continue(game_t *game) {
  game->running = !game->running;
}

int update_game(game_t *game) {
  if (!game->running)
    return 1;

  seconds_counter++;
  if (seconds_counter % TICKS_PER_SECOND == 0) {
    game->game_time++;
    draw_time(game);
  }

  move_snake(game->snake);

  return 0;
}

void set_direction(game_t *game, char direction) {
  if (!game->running)
    return;
  else
    change_direction(game->snake, direction);
  return;
}

void draw_static(game_t *game) {
  vg_draw_rectangle(50, 150, 924, 4, 7);
  vg_draw_rectangle(50, 700, 924, 4, 7);
  vg_draw_rectangle(50, 150, 4, 550, 7);
  vg_draw_rectangle(974, 150, 4, 554, 7);
  xpm_image_t img;

  xpm_load(title_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 262, 0);

  // por as letras SNAKE
  // TIME - 00:00
  xpm_load(t_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 774, 120);
  xpm_load(i_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 796, 120);
  xpm_load(m_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 808, 120);
  xpm_load(e_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 849, 120);
  xpm_load(dash_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 875, 120);

  // POINTS -

  xpm_load(p_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 54, 120);
  xpm_load(o_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 76, 120);
  xpm_load(i_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 98, 120);
  xpm_load(n_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 110, 120);
  xpm_load(t_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 137, 120);
  xpm_load(s_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 159, 120);
  xpm_load(dash_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 185, 120);
  return;
}

void draw_points(game_t *game) {
  vg_draw_rectangle(200, 120, 66, 21, 0);
  xpm_image_t img;
  // xpm_image_t img;
  if (game->points == 0) {
    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 200, 120);
  }
  else if (game->points < 100) {
    int arrayIndex = game->points / 10;
    xpm_load(numbers[arrayIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 200, 120);

    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 222, 120);
  }
  else if (game->points < 1000) {
    int arrayCentIndex = game->points / 100;
    int arrayDezIndex = (game->points - 100 * arrayCentIndex) / 10;
    xpm_load(numbers[arrayCentIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 200, 120);
    xpm_load(numbers[arrayDezIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 222, 120);
    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 244, 120);
  }
  else {
    int arrayMilIndex = game->points / 1000;
    int arrayCentIndex = (game->points - 1000 * arrayMilIndex) / 100;
    int arrayDezIndex = (game->points - 100 * arrayCentIndex - 1000 * arrayMilIndex) / 10;
    xpm_load(numbers[arrayMilIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 200, 120);
    xpm_load(numbers[arrayCentIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 222, 120);
    xpm_load(numbers[arrayDezIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 244, 120);
    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 266, 120);
  }

  // colocar o zero no final de cada um
  return;
}

void draw_time(game_t *game) {
  vg_draw_rectangle(890, 120, 76, 21, 0);
  xpm_image_t img;
  int min = game->game_time / 60;
  if (min > 10) {
    int arrayDez = min / 10;
    int arrayUni = min - 10 * arrayDez;
    int secs = game->game_time - 60 * min;
    int arraySecDez = secs / 10;
    int arraySecUni = secs - 10 * arraySecDez;
    xpm_load(numbers[arrayDez], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 890, 120);
    xpm_load(numbers[arrayUni], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 912, 120);
    xpm_load(two_points_xpm, XPM_INDEXED, &img);
    vg_draw_xpm(&img, 934, 120);
    xpm_load(numbers[arraySecDez], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 944, 120);
    xpm_load(numbers[arraySecUni], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 966, 120);
  }
  else {
    int arrayUni = min;
    int secs = game->game_time - 60 * min;
    int arraySecDez = secs / 10;
    int arraySecUni = secs - 10 * arraySecDez;
    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 890, 120);
    xpm_load(numbers[arrayUni], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 912, 120);
    xpm_load(two_points_xpm, XPM_INDEXED, &img);
    vg_draw_xpm(&img, 934, 120);
    xpm_load(numbers[arraySecDez], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 944, 120);
    xpm_load(numbers[arraySecUni], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 966, 120);
  }

  return;
}

uint16_t get_x_i() {
  return x_i;
}
uint16_t get_y_i() {
  return y_i;
}
uint16_t get_x_f() {
  return x_f;
}
uint16_t get_y_f() {
  return y_f;
}
