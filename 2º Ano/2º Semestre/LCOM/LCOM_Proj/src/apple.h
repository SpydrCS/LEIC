#pragma once
#include "vbe.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
static unsigned int apple_default_size = 30; ///< default speed for the players (in pixels/frame)

typedef struct apple {
  int x, y; ///< player position
  int size; /// tamanho da cobra
  unsigned int color;
} apple_t;

/**
 * @brief Create a apple object
 *
 * @param x
 * @param y
 * @return apple_t
 */
apple_t *create_apple();

/**
 * @brief free alocated memmory of the apple
 *
 * @param apple
 */
void destroy_apple(apple_t *apple);

/**
 * @brief draws the apple
 *
 * @param apple
 */
void draw_apple(apple_t *apple);
