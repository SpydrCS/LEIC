#pragma once

#include "cursor.h"
#include "game.h"

/**
 * @brief have values for each button
 *
 */
typedef enum buttom_selection {
  play_selection = 0,   ///< There was a click on Play Button
  scores_selection = 1, ///< There was a click on Scores button
  exit_selection = 2,   ///< There was a click on Exit button
  no_selection = -1     ///< There was no click on a button
} click_t;

/**
 * @brief Button Class
 *
 */
typedef struct button {
  int xi;          ///< Button's left boundary
  int yi;          ///< Button's top boundary
  int xf;          ///< Button's right boundary
  int yf;          ///< Button's bottom boundary
  int highlighted; ///< True when the button is being hovered, false otherwise

} button_t;

/**
 * @brief Menu Class
 *
 */
typedef struct menu {
  button_t *play_button;   ///< Play button
  button_t *scores_button; ///< Scores button
  button_t *exit_button;   ///< Exit button
  cursor_t *cursor;
} menu_t;

/**
 * @brief Create a button object
 *
 * @param xi
 * @param yi
 * @param len
 * @return button_t*
 */

/**
 * @brief Create a button object
 *
 * @param xi
 * @param yi
 * @param len_x
 * @param len_y
 * @return button_t*
 */
button_t *create_button(int xi, int yi, int len_x, int len_y);

/**
 * @brief Create a menu object
 *
 * @return menu_t*
 */
menu_t *create_menu();

/**
 * @brief Create a play button object
 *
 * @return button_t*
 */
button_t *create_play_button();

/**
 * @brief Create a exit button object
 *
 * @return button_t*
 */
button_t *create_exit_button();

/**
 * @brief draws play button
 *
 * @param button
 */
void draw_play_button(button_t *button, int x, int y);

/**
 * @brief draws exit button
 *
 * @param button
 */
void draw_exit_button(button_t *button, int x, int y);

/**
 * @brief draws_menu buttons and others
 *
 * @param menu
 */
void draw_menu(menu_t *menu);

/**
 * @brief Draws the SNAKE in Menu
 *
 */
void draw_title();

/**
 * @brief draws back ground snakes
 *
 */
void draw_background_menu();

/**
 * @brief
 *
 * @param menu
 */
void change_highlighted(menu_t *menu);

/**
 * @brief
 *
 * @param game
 */
void draw_end_game_points(game_t *game);

/**
 * @brief
 *
 * @param menu
 * @param game
 */
void draw_end_game_menu(menu_t *menu, game_t *game);

/**
 * @brief
 *
 * @param game
 */
void draw_static_end_menu(game_t *game);

/**
 * @brief
 *
 * @param game
 */
void draw_time_end_menu(game_t *game);
