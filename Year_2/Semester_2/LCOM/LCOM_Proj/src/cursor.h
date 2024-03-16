#pragma once
#include <stdio.h>
#include <stdlib.h>



typedef struct cursor {
  int x;
  int y;

} cursor_t;

/**
 * @brief Create a cursor object
 *
 * @param x
 * @param y
 * @return cursor_t
 */
cursor_t *create_cursor(int x, int y);

/**
 * @brief Delete a cursor object
 *
 * @param cursor pointer to the variable
 * @return void
 */
void delete_cursor(cursor_t *cursor);


/**
 * @brief Drawn a cursor object
 *
 * @param cursor pointer to the variable
 * @return void
 */
void draw_cursor(cursor_t *cursor);


/**
 * @brief Move a cursor object
 *
 * @param cursor pointer to the variable
 * @param difx
 * @param dify
 * @return void
 */
void move_cursor(cursor_t *cursor, int difx, int dify);
