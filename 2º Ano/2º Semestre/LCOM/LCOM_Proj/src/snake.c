#include "snake.h"

static uint16_t x_i = 50, x_f = 974, y_i = 150, y_f = 700;

snake_t *new_snake(uint32_t color) {
  snake_t *snake = malloc(sizeof(snake_t));

  if (snake == NULL)
    return NULL;

  snake->color = color;
  snake->direction = 'E';
  snake->size = tail_size;
  snake->speed = speed;
  for (int i = 0; i < tail_size; i++) {
    snake->positions[i][0] = 300 - i * snake->speed;
    snake->positions[i][1] = 300;
  }

  snake->x = 300;
  snake->y = 300;

  return snake;
}

void delete_snake(snake_t *snake) {
  free(snake);
}

int change_direction(snake_t *snake, char direction) {
  if (direction != 'N' && direction != 'S' && direction != 'W' && direction != 'E')
    return -1;

  // Nao podemos mudar de direção 180º
  switch (snake->direction) {
    case 'N':
      if (direction == 'S')
        return -1;
      break;
    case 'S':
      if (direction == 'N')
        return -1;
      break;
    case 'E':
      if (direction == 'W')
        return -1;
      break;
    case 'W':
      if (direction == 'E')
        return -1;
      break;

    default:
      break;
  }

  snake->direction = direction;
  return 0;
}

void move_snake(snake_t *snake) {
  // Mover a snake tendo em consideração o seu speed atual
  int aux[snake->size][2];
  switch (snake->direction) {
    case 'N':
      for (int i = 0; i < snake->size; i++) {
        if (i == 0) {
          aux[i][0] = snake->x;
          aux[i][1] = snake->y - snake->speed;
        }
        else {
          aux[i][0] = snake->positions[i - 1][0];
          aux[i][1] = snake->positions[i - 1][1];
        }
      }
      snake->y -= snake->speed;
      break;

    case 'S':
      for (int i = 0; i < snake->size; i++) {
        if (i == 0) {
          aux[i][0] = snake->x;
          aux[i][1] = snake->y + snake->speed;
        }
        else {
          aux[i][0] = snake->positions[i - 1][0];
          aux[i][1] = snake->positions[i - 1][1];
        }
      }
      snake->y += snake->speed;
      break;

    case 'E':
      for (int i = 0; i < snake->size; i++) {
        if (i == 0) {
          aux[i][0] = snake->x + snake->speed;
          aux[i][1] = snake->y;
        }
        else {
          aux[i][0] = snake->positions[i - 1][0];
          aux[i][1] = snake->positions[i - 1][1];
        }
      }
      snake->x += snake->speed;
      break;

    case 'W':
      for (int i = 0; i < snake->size; i++) {
        if (i == 0) {
          aux[i][0] = snake->x - snake->speed;
          aux[i][1] = snake->y;
        }
        else {
          aux[i][0] = snake->positions[i - 1][0];
          aux[i][1] = snake->positions[i - 1][1];
        }
      }
      snake->x -= snake->speed;
      break;
  }

  for (int i = 0; i < snake->size; i++) {
    snake->positions[i][0] = aux[i][0];
    snake->positions[i][1] = aux[i][1];
  }

  return;
}

void increase_speed(snake_t *snake, int added_speed) {
  if (snake->speed - added_speed >= 12) {
    snake->speed = 12;
  }
  else {
    snake->speed += added_speed;
  }
}

void decrease_speed(snake_t *snake, int added_speed) {
  if (snake->speed - added_speed <= 2) {
    snake->speed = 2;
  }
  else {
    snake->speed -= added_speed;
  }
}

void grow_snake(snake_t *snake) {
  // crescer a cauda quando esta a ir para subir
  if ((snake->positions[snake->size - 2][0] == snake->positions[snake->size - 3][0]) && (snake->positions[snake->size - 2][1] > snake->positions[snake->size - 3][1])) {
    snake->positions[snake->size - 1][0] = snake->positions[snake->size - 2][0];
    snake->positions[snake->size - 1][1] = snake->positions[snake->size - 2][1] + snake->speed;
  }
  // crescer a cauda quando esta a ir para descer
  else if ((snake->positions[snake->size - 2][0] == snake->positions[snake->size - 3][0]) && (snake->positions[snake->size - 2][1] < snake->positions[snake->size - 3][1])) {
    snake->positions[snake->size - 1][0] = snake->positions[snake->size - 2][0];
    snake->positions[snake->size - 1][1] = snake->positions[snake->size - 2][1] - snake->speed;
  }
  // crescer a cauda quando esta a ir para a direita
  else if ((snake->positions[snake->size - 2][0] < snake->positions[snake->size - 3][0]) && (snake->positions[snake->size - 2][1] == snake->positions[snake->size - 3][1])) {
    snake->positions[snake->size - 1][0] = snake->positions[snake->size - 2][0] - snake->speed;
    snake->positions[snake->size - 1][1] = snake->positions[snake->size - 2][1];
  }
  // crescer a cauda quando esta a ir para a esquerda
  else if ((snake->positions[snake->size - 2][0] > snake->positions[snake->size - 3][0]) && (snake->positions[snake->size - 2][1] == snake->positions[snake->size - 3][1])) {
    snake->positions[snake->size - 1][0] = snake->positions[snake->size - 2][0] + snake->speed;
    snake->positions[snake->size - 1][1] = snake->positions[snake->size - 2][1];
  }
}

int draw_snake(snake_t *snake) {

  if (check_collision(snake)) {
    return 1;
  }
  else {
    for (int i = 0; i < snake->size; i++) {
      if (i == snake->size - 1) {
        vg_draw_rectangle(snake->positions[i][0], snake->positions[i][1], 3, 3, 0);
      }
      else {

        vg_draw_rectangle(snake->positions[i][0], snake->positions[i][1], 3, 3, snake->color);
      }
    }
  }

  return 0;
}

int check_collision(snake_t *snake) {
  if (snake->x >= x_f - 7 || snake->x < x_i + 7) {
    return 1;
  }

  if (snake->y >= y_f - 7 || snake->y < y_i + 7) {

    return 1;
  }

  for (int i = 1; i < snake->size; i++) {
    if ((snake->positions[i][0] == snake->x) && (snake->positions[i][1] == snake->y)) {
      return 1;
    }
  }

  return 0;
}
