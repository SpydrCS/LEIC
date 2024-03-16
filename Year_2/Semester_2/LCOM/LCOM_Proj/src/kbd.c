#include "kbd.h"
#include "i8042.h"
#include "i8254.h"
#include <lcom/lcf.h>
#include <minix/sysutil.h>
#include <stdbool.h>
#include <stdint.h>

// global variables
int kb_hookID = 1;        // hook_id used for the keyboard
uint32_t inb_counter = 0; // global sys_inb counter
uint8_t code;             // global variable to pass the scancodes from the output buffer to lab3.c
int kbd_err;
int two_byte = 0;
int count;
int isobf;

int(util_sys_inb_cnt)(int port, uint8_t *value) {
  count++;
  return util_sys_inb(port, value);
}

void(kbc_ih)() {
  uint8_t status;

  if (util_sys_inb_cnt(KBC_ST_REG, &status)) {
    kbd_err = 1;
    return;
  }

  if ((status & OBF)) {
    if (util_sys_inb_cnt(KBC_OUT_BUF, &code)) {
      kbd_err = 1;
      return;
    }
  }

  if (status & (PAR_ERR | TIMEOUT_ERR)) {
    kbd_err = 1;
    return;
  }

  if (code == TWO_B_LONG) {

    two_byte = 1;
  }

  return;
}

void(kbc_ih_poll)() {
  uint8_t status;
  two_byte = 0;
  isobf = 0;
  if (util_sys_inb_cnt(KBC_ST_REG, &status)) {
    printf("Error getting the status register!\n");
    return;
  }

  if ((status & OBF)) {
    isobf = 1;
    if (util_sys_inb_cnt(KBC_OUT_BUF, &code)) {
      isobf = 0;
      return;
    }
  }

  if (status & (PAR_ERR | TIMEOUT_ERR | AUX)) {
    isobf = 0;
    return;
  }

  tickdelay(micros_to_ticks(WAIT_KBC));

  if (code == TWO_B_LONG) {

    two_byte = 1;
    if (util_sys_inb_cnt(KBC_ST_REG, &status)) {
      isobf = 0;
      printf("Error getting the status register!\n");
      return;
    }

    if ((status & OBF)) {
      isobf = 1;
      if (util_sys_inb_cnt(KBC_OUT_BUF, &code)) {
        isobf = 0;
        printf("Error getting the contents of the output buffer!\n");
        return;
      }
    }
    if ((status & (PAR_ERR | TIMEOUT_ERR | AUX))) {
      isobf = 0;
      printf("Error paring or due to timeout!\n");
      return;
    }
    tickdelay(micros_to_ticks(WAIT_KBC));
  }
  if (util_sys_inb_cnt(KBC_ST_REG, &status)) {
    isobf = 0;
    printf("Error getting the status register!\n");
    return;
  }
  return;
}

int(kbd_subscribe_int)(uint8_t *irq_bitmask) {
  *irq_bitmask = BIT(kb_hookID);
  if (sys_irqsetpolicy(IRQ1_KEYBOARD, IRQ_REENABLE | IRQ_EXCLUSIVE, &kb_hookID))
    return 1;

  return 0;
}

int(kbd_unsubscribe_int)() {

  uint8_t status;
  if (util_sys_inb_cnt(KBC_ST_REG, &status)) {
    printf("Error getting status\n");
    return 1;
  }
  if (status & OBF) { // limpar o output buffer
    util_sys_inb_cnt(KBC_OUT_BUF, &code);
  }

  if (sys_irqrmpolicy(&kb_hookID))
    return 1;

  return 0;
}

int(kbc_command_handler)(int reg, uint8_t command) {
  uint8_t status;
  int i = 0;
  while (i < 10) {
    if (util_sys_inb_cnt(KBC_ST_REG, &status)) {
      printf("Error getting status\n");
      return 1;
    }
    if (status & OBF) { // clean the output buffer in case of it being full
      util_sys_inb_cnt(KBC_OUT_BUF, &code);
    }
    if (!(status & IBF)) { // input buffer not full
      if (sys_outb(reg, command)) {
        printf("Error writing the command to the register\n");
        return 1;
      }
      return 0;
    }
    i++;
  }
  return 0;
}

int(kbd_int_enable)() {
  uint8_t cmd_B;

  if (kbc_command_handler(KBC_CMD_REG, RD_COM)) { // enable read
    printf("Error writing the read command in the status port\n");
    return 1;
  }

  if (util_sys_inb_cnt(KBC_OUT_BUF, &cmd_B)) {
    printf("Error reading the output buffer status (and writing in the cmd_B)\n");
    return 1;
  }
  cmd_B |= EN_INT_KBD; // interuption enable bit

  if (kbc_command_handler(KBC_CMD_REG, WR_COM)) { // enable write
    printf("Error writing the output buffer status in the status register\n");
    return 1;
  }

  if (kbc_command_handler(KBC_OUT_BUF, cmd_B)) {
    printf("Error writing the new output buffer status in the register (with interruptions enabled)\n");
    return 1;
  }

  return 0;
}

int kbd_game_event_handler(kbd_event *p) {
  kbc_ih();
  if (two_byte) {
    *p = any_pressed;
    two_byte = 0;
  }
  else {
    switch (code) {
      case W_MAKE:
        *p = W_pressed;
        break;
      case A_MAKE:
        *p = A_pressed;
        break;
      case D_MAKE:
        *p = D_pressed;
        break;
      case S_MAKE:
        *p = S_pressed;
        break;
      case ESC:
        *p = ESC_pressed;
        break;
      case ENTER_MAKE:
        *p = ENTER_pressed;
        break;
      default:
        *p = any_pressed;
        break;
    }
  }

  return 0;
}
