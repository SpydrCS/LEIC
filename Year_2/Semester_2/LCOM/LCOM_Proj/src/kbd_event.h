#pragma once

/**
 * @brief keyboard events
 *
 */
typedef enum kbd_event {
  W_pressed = 0,
  A_pressed = 1,
  D_pressed = 2,
  S_pressed = 3,
  UP_pressed = 4,
  DOWN_pressed = 5,
  W_released = 6,
  A_released = 7,
  D_released = 8,
  S_released = 9,
  UP_released = 10,
  DOWN_released = 11,

  any_pressed = 12,
  any_released = 13,

  ESC_pressed = 14,

  ENTER_pressed = 15

} kbd_event;
