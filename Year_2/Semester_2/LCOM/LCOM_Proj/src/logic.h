#pragma once

#include "apple.h"
#include "game.h"
#include "kbd_event.h"
#include "menu.h"

/**
 * @brief Game State machine
 *
 */
typedef enum game_state {
  main_menu = 0,
  playing = 1,
  ended_game = 2,
  exit_procedure = 3
} game_state_t;

/**
 * @brief creates a game_t object
 *
 */
void initialize_game();

/**
 * @brief creates a menu object
 *
 */
void initialize_menu();

/**
 * @brief Frees the memory of all the objects created for the logic module
 *
 */
void delete_all();

/**
 * @brief Update the state machine of the logic
 *
 * @param state - State to tupdate to
 */
void update_game_state(int state);

/**
 * @brief Handles the keyboard event logic
 *
 * @param p - Keyboard event to be processed
 * @return int - Returns 0 if sucessful or 1 if not.
 */
int kbd_logic(kbd_event *p);
/**
 * @brief - Handles the timer event logic
 *
 * @return int - Returns 0 if sucessful or 1 if not.
 */
int timer_logic();

/**
 * @brief - Handles mouse events
 *
 * @param ev
 * @return int
 */
int mouse_logic(struct mouse_ev *ev);

/**
 * @brief inizializes menu
 *
 */
void initialize_menu();
