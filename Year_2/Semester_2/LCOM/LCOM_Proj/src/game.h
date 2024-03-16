#pragma once
#include "apple.h"
#include "snake.h"

#define TICKS_PER_SECOND 60

/**
 * @brief Struct game_t. Acts as class GAME.
 * Holds game specific information (snake, game time, points, if it is running or paused)
 *
 */
typedef struct game_cl {
  snake_t *snake;     ///< Left player C pointer
  uint16_t game_time; ///< Current time left in game
  int points;         ///< Number of rounds won by player 1
  apple_t *apple;
  bool running; ///< When true the game is running, when false the game is paused

} game_t;

/**
 * @brief creates a new game
 *
 * @return game_t*
 */
game_t *new_game();

/**
 * @brief delete the game indicated (frees the alocated memmory)
 *
 * @param game
 */
void delete_game(game_t *game);

/**
 * @brief updates timer and snake position
 *
 * @param game
 * @return int
 */
int update_game(game_t *game);

/**
 * @brief resets game info
 *
 * @param game
 */
void reset_game(game_t *game);

/**
 * @brief pause and continues the game with the game info -> running
 *
 * @param game
 */
void game_pause_continue(game_t *game);

/**
 * @brief Draws the number of points of the snake
 *
 * @param game C pointer to the game object
 */
void draw_points(game_t *game);

/**
 * @brief Draws the timer
 *
 * @param game C pointer to the game object
 */
void draw_time(game_t *game);

/**
 * @brief Set the direction object
 *
 * @param game
 * @param direction
 */
void set_direction(game_t *game, char direction);

/**
 * @brief draw the current points of the player
 *
 * @param game
 */
void draw_points(game_t *game);

/**
 * @brief draw the current time of game
 *
 * @param game
 */
void draw_time(game_t *game);

/**
 * @brief draws the static things of the game (SNAKE and borders)
 *
 * @param game
 */
void draw_static(game_t *game);

/**
 * @brief Get the x i object
 *
 * @return uint16_t
 */
uint16_t get_x_i();
/**
 * @brief Get the y i object
 *
 * @return uint16_t
 */
uint16_t get_y_i();
/**
 * @brief Get the x f object
 *
 * @return uint16_t
 */
uint16_t get_x_f();
/**
 * @brief Get the y f object
 *
 * @return uint16_t
 */
uint16_t get_y_f();
