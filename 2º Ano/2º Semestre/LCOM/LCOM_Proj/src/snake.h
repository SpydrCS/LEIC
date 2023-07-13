#include "vbe.h"
#include <lcom/lcf.h>

static unsigned int speed = 4; ///< default speed for the players (in pixels/frame)
static uint16_t tail_size = 10;

typedef struct snake {
  char direction;     ///< direction to where the player is moving
  unsigned int color; ///< the motorcicle trail color
  unsigned int speed; ///< speed of the player, can be changed by boost
  int x, y;           ///< player position
  int size;           /// tamanho da cobra
  int positions[100][2];
} snake_t;

/**
 * @brief Creates a new Snake
 *
 * @param color color of the snake
 * @return snake_t* if the memmory allocation was correct or null pointer if it was not.
 */
snake_t *new_snake(uint32_t color);

/**
 * @brief destructor of snake_t. Frees the allocated memmory
 *
 * @param snake pointer to be deleted
 */
void delete_snake(snake_t *snake);

/**
 * @brief Changes the direction of the snake
 *
 * @param snake snake_t that we will change the direction
 * @param direction direction to be changed
 * @return int 0 if successfull, -1 if not
 */
int change_direction(snake_t *snake, char direction);

/**
 * @brief moves the snake according to his direction and speed
 *
 * @param snake
 */
void move_snake(snake_t *snake);

/**
 * @brief draws the tail of the snake
 *
 * @param snake
 * @return int
 */
int draw_snake(snake_t *snake);

/**
 * @brief
 *
 * @param snake
 * @return int 1 means there was collision, 0 no collision
 */
int check_collision(snake_t *snake);

/**
 * @brief make snake bigger
 *
 * @param snake
 */
void grow_snake(snake_t *snake);

/**
 * @brief
 *
 * @param snake
 * @param added_speed
 */
void increase_speed(snake_t *snake, int added_speed);

/**
 * @brief
 *
 * @param snake
 * @param added_speed
 */
void decrease_speed(snake_t *snake, int added_speed);
