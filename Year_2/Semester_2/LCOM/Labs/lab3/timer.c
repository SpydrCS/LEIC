#include <lcom/lcf.h>
#include <lcom/timer.h>

#include <stdint.h>

#include "i8254.h"

extern int counter;
extern int hook_id;

int(timer_set_frequency)(uint8_t timer, uint32_t freq) {
  if (timer > 2 || timer < 0) {
    printf("Error setting the timer\n");
    return 1;
  }

  uint8_t controlWord;

  if (timer_get_conf(timer, &controlWord)) {
    printf("Error getting config");
    return 1;
  }

  // Make sure that you do not change the 4 least significant bits
  // SOlution
  controlWord <<= 4;
  controlWord >>= 4;

  // Setting Timer
  switch (timer) {
    case 0:
      controlWord |= TIMER_SEL0;
      break;
    case 1:
      controlWord |= TIMER_SEL1;
      break;
    case 2:
      controlWord |= TIMER_SEL2;
      break;
    default:
      printf("Invalid timer!\n");
      return 1;
  }

  // Setting Counter LSB follwed MSB
  controlWord |= TIMER_LSB_MSB;

  // Send Control Word
  if (sys_outb(TIMER_CTRL, controlWord)) {
    printf("Error sending the control word\n");
    return 1;
  }

  uint16_t division = TIMER_FREQ / freq;

  uint8_t lsb, msb;

  util_get_LSB(division, &lsb);
  util_get_MSB(division, &msb);

  uint8_t tp = TIMER_0 + timer;

  if (sys_outb(tp, lsb)) {
    printf("Error writing LSB bits\n");
    return 1;
  }

  if (sys_outb(tp, msb)) {
    printf("Error writing MSB bits\n");
    return 1;
  }

  return 0;
}

int(timer_subscribe_int)(uint8_t *bit_no) {

  hook_id = *bit_no;

  if (sys_irqsetpolicy(TIMER0_IRQ, IRQ_REENABLE, &hook_id))
    return 1;

  return 0;
}

int(timer_unsubscribe_int)() {

  if (sys_irqrmpolicy(&hook_id))
    return 1;

  return 0;
}

void(timer_int_handler)() {
  counter++;
}

int(timer_get_conf)(uint8_t timer, uint8_t *st) {

  if (timer > 2 || timer < 0) {
    printf("Error setting the timer\n");
    return 1;
  }
  // create read back end command
  uint32_t cmd = (TIMER_RB_SEL(timer) | TIMER_RB_COUNT_ | TIMER_RB_CMD);

  if (sys_outb(TIMER_CTRL, cmd)) {
    printf("Error sending byte command to timerControl\n");
    return 1;
  }

  // Check what port to read from
  uint8_t in_port;
  if (timer == 0) {
    in_port = TIMER_0;
  }
  else if (timer == 1) {
    in_port = TIMER_1;
  }
  else if (timer == 2) {
    in_port = TIMER_2;
  }
  else {
    return 1;
  }

  // read status to ST
  if (util_sys_inb(in_port, st)) {
    return 1;
  }

  return 0;
}

int(timer_display_conf)(uint8_t timer, uint8_t st,
                        enum timer_status_field field) {

  if (timer > 2 || timer < 0) {
    printf("Error setting the timer\n");
    return 1;
  }

  // passar o st para timer_status_field
  union timer_status_field_val conf;

  switch (field) {
    case tsf_all:
      conf.byte = st;
      break;
    case tsf_initial:
      // passar o bit 4 e 5
      conf.in_mode = (st & BIT(4)) | (st & BIT(5));
      conf.in_mode >>= 4;
      break;
    case tsf_mode:
      // Passar bit 3 2 1
      conf.count_mode = (st & BIT(1)) | (st & BIT(2)) | (st & BIT(3));
      conf.count_mode >>= 1;

      break;
    case tsf_base:
      conf.bcd = st & BIT(0);
      break;

    default:
      printf("Error in Field\n");
      return 1;
      break;
  }

  // chamar timer_print_config()
  if (timer_print_config(timer, field, conf)) {
    printf("Error printing config\n");
    return 1;
  }

  return 0;
}
