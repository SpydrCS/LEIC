#include <lcom/lcf.h>

#include <stdint.h>

int(util_get_LSB)(uint16_t val, uint8_t *lsb) {

  *lsb = (uint8_t) val;

  return 0;
}

int(util_get_MSB)(uint16_t val, uint8_t *msb) {

  val >>= 8;

  *msb = (uint8_t) val;

  return 0;
}

int(util_sys_inb)(int port, uint8_t *value) {
  uint32_t aux;
  if (sys_inb(port, &aux)) {
    printf("Error reading from port util_sys_inb\n");
    return 1;
  }

  *value = (uint8_t) (aux);
  return 0;
}
