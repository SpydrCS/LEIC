#include "logic.h"
#include <lcom/lcf.h>

static game_state_t main_state = main_menu;

static game_t *game;
static menu_t *menu;

void initialize_game() {
  game = new_game();
}

void initialize_menu() {
  menu = create_menu();
}

void update_game_state(int state) {
  main_state = state;
  vg_clear_screen();
  if (main_state == main_menu) {
    draw_menu(menu);
  }
  else if (main_state == playing) {
    draw_static(game);
    draw_points(game);
  }
}

int kbd_logic(kbd_event *p) {

  switch (main_state) {

    case main_menu:
      switch (*p) {
        case W_pressed:
          change_highlighted(menu);
          break;
        case S_pressed:
          change_highlighted(menu);
          break;
        case ENTER_pressed:
          if (menu->play_button->highlighted) {
            update_game_state(playing);
          }
          else {
            return 1;
          }
          break;
        default:
          break;
      }

      break;

    case playing:

      switch (*p) {
        case W_pressed:
          set_direction(game, 'N');
          break;

        case A_pressed:
          set_direction(game, 'W');
          break;

        case D_pressed:
          set_direction(game, 'E');
          break;

        case S_pressed:
          set_direction(game, 'S');
          break;

          // global keys

        case ENTER_pressed:
          game_pause_continue(game);
          break;
        default:
          break;
      }
      break;

    case ended_game:
      switch (*p) {
        case D_pressed:
          change_highlighted(menu);
          break;
        case A_pressed:
          change_highlighted(menu);
          break;
        case ENTER_pressed:
          if (menu->play_button->highlighted) {
            reset_game(game);

            update_game_state(playing);
          }
          else {
            return 1;
          }
          break;
        default:
          break;
      }
      break;
    default:
      break;
  }
  return 0;
}

int mouse_logic(struct mouse_ev *ev) {
  switch (main_state) {
    case main_menu:
      break;

    case playing:
      if (ev->type == LB_RELEASED) {
        increase_speed(game->snake, 2);
      }
      else if (ev->type == RB_RELEASED) {
        decrease_speed(game->snake, 2);
      }
      break;

    default:
      break;
  }

  return 0;
}

int timer_logic() {
  copyBuffer();

  switch (main_state) {
    case main_menu:
      draw_menu(menu);
      break;

    case playing:

      if (update_game(game) == 1) {
        return 0; // game is paused or hasn't started
      }

      if (((game->snake->x >= game->apple->x) && (game->snake->x <= game->apple->x + game->apple->size)) && ((game->snake->y >= game->apple->y) && (game->snake->y <= game->apple->y + game->apple->size))) {
        game->points += 10;
        destroy_apple(game->apple);
        game->snake->size += 1;
        game->apple = create_apple();
        draw_apple(game->apple);
        grow_snake(game->snake);
        draw_points(game);
      }
      else {

        draw_apple(game->apple);
      }

      if (draw_snake(game->snake) == 1)
        update_game_state(ended_game);

      break;

    case ended_game:
      draw_end_game_menu(menu, game);
      break;
    default:
      break;
  }

  return 0;
}
