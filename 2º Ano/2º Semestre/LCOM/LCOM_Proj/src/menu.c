#include "menu.h"
#include "vbe.h"
#include "xpm/xpm.h"

button_t *create_button(int xi, int yi, int len_x, int len_y) {
  button_t *button = malloc(sizeof(button_t));

  button->xi = xi;
  button->xf = xi + len_x;
  button->yi = yi;
  button->yf = yi + len_y;
  button->highlighted = 0;

  return button;
}

menu_t *create_menu() {
  menu_t *menu = malloc(sizeof(menu_t));

  menu->play_button = create_play_button();
  menu->exit_button = create_exit_button();
  menu->play_button->highlighted = 1;
  return menu;
}

button_t *create_play_button() {
  button_t *button_play = create_button(362, 288, 300, 80);

  return button_play;
}

button_t *create_exit_button() {
  button_t *button_exit = create_button(362, 548, 300, 80);

  return button_exit;
}

void draw_play_button(button_t *button, int x, int y) {
  xpm_image_t img;

  if (button->highlighted) {
    xpm_load(play_hovered_xpm, XPM_INDEXED, &img);

    vg_draw_xpm(&img, x, y);
  }
  else {
    xpm_load(play_xpm, XPM_INDEXED, &img);

    vg_draw_xpm(&img, x, y);
  }

  return;
}

void draw_exit_button(button_t *button, int x, int y) {
  xpm_image_t img;

  if (button->highlighted) {
    xpm_load(exit_hovered_xpm, XPM_INDEXED, &img);

    vg_draw_xpm(&img, x, y);
  }
  else {
    xpm_load(exit_xpm, XPM_INDEXED, &img);

    vg_draw_xpm(&img, x, y);
  }

  return;
}

void draw_title() {
  xpm_image_t img;

  xpm_load(title_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 262, 100);
  return;
}

void draw_background_menu() {
  load_background();
  draw_background();
  return;
}

void change_highlighted(menu_t *menu) {
  if (menu->play_button->highlighted) {
    menu->play_button->highlighted = 0;
    menu->exit_button->highlighted = 1;
  }
  else {
    menu->play_button->highlighted = 1;
    menu->exit_button->highlighted = 0;
  }
}

void draw_menu(menu_t *menu) {
  draw_background_menu();
  draw_title();
  draw_exit_button(menu->exit_button, 362, 450);
  draw_play_button(menu->play_button, 362, 320);
}

void draw_end_game_menu(menu_t *menu, game_t *game) {
  draw_background_menu();

  draw_exit_button(menu->exit_button, 532, 548);
  draw_play_button(menu->play_button, 192, 548);
  draw_end_game_points(game);
  draw_time_end_menu(game);
  draw_static_end_menu(game);
}

void draw_end_game_points(game_t *game) {
  xpm_image_t img;
  // xpm_image_t img; 342
  if (game->points == 0) {
    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 334, 400);
  }
  else if (game->points < 100) {
    int arrayIndex = game->points / 10;
    xpm_load(numbers[arrayIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 322, 400);

    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 345, 400);
  }
  else if (game->points < 1000) {
    int arrayCentIndex = game->points / 100;
    int arrayDezIndex = (game->points - 100 * arrayCentIndex) / 10;
    xpm_load(numbers[arrayCentIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 312, 400);
    xpm_load(numbers[arrayDezIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 334, 400);
    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 355, 400);
  }
  else {
    int arrayMilIndex = game->points / 1000;
    int arrayCentIndex = (game->points - 1000 * arrayMilIndex) / 100;
    int arrayDezIndex = (game->points - 100 * arrayCentIndex - 1000 * arrayMilIndex) / 10;
    xpm_load(numbers[arrayMilIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 300, 400);
    xpm_load(numbers[arrayCentIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 322, 400);
    xpm_load(numbers[arrayDezIndex], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 347, 400);
    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 369, 400);
  }

  // colocar o zero no final de cada um
  return;
}
// 682
void draw_time_end_menu(game_t *game) {
  xpm_image_t img;
  int min = game->game_time / 60;
  if (min > 10) {
    int arrayDez = min / 10;
    int arrayUni = min - 10 * arrayDez;
    int secs = game->game_time - 60 * min;
    int arraySecDez = secs / 10;
    int arraySecUni = secs - 10 * arraySecDez;
    xpm_load(numbers[arrayDez], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 644, 400);
    xpm_load(numbers[arrayUni], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 666, 400);
    xpm_load(two_points_xpm, XPM_INDEXED, &img);
    vg_draw_xpm(&img, 688, 400);
    xpm_load(numbers[arraySecDez], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 698, 400);
    xpm_load(numbers[arraySecUni], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 720, 400);
  }
  else {
    int arrayUni = min;
    int secs = game->game_time - 60 * min;
    int arraySecDez = secs / 10;
    int arraySecUni = secs - 10 * arraySecDez;
    xpm_load(numbers[0], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 644, 400);
    xpm_load(numbers[arrayUni], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 666, 400);
    xpm_load(two_points_xpm, XPM_INDEXED, &img);
    vg_draw_xpm(&img, 688, 400);
    xpm_load(numbers[arraySecDez], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 698, 400);
    xpm_load(numbers[arraySecUni], XPM_INDEXED, &img);
    vg_draw_xpm(&img, 720, 400);
  }

  return;
}

void draw_static_end_menu(game_t *game) {

  xpm_image_t img;

  xpm_load(title_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 262, 150);

  // por as letras SNAKE
  // TIME - 00:00  682
  xpm_load(t_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 644, 350);
  xpm_load(i_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 666, 350);
  xpm_load(m_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 688, 350);
  xpm_load(e_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 729, 350);

  // POINTS -342 131 66

  xpm_load(p_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 276, 350);
  xpm_load(o_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 298, 350);
  xpm_load(i_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 320, 350);
  xpm_load(n_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 332, 350);
  xpm_load(t_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 359, 350);
  xpm_load(s_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 381, 350);

  return;
}
