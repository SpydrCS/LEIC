#include "i8042.h"
#include "i8254.h"
#include "kbd.h"
#include <lcom/lab3.h>
#include <lcom/lcf.h>
#include <lcom/timer.h>
#include <minix/sysutil.h>
#include <stdbool.h>
#include <stdint.h>

int hookID = 1;
int hook_id = 0;
int kbd_err = 0;
uint8_t code = 0;
int two_byte = 0;
int count = 0;
int isobf = 0; // is output buffer full
int counter = 0;

int main(int argc, char *argv[]) {
  // sets the language of LCF messages (can be either EN-US or PT-PT)
  lcf_set_language("EN-US");

  // enables to log function invocations that are being "wrapped" by LCF
  // [comment this out if you don't want/need it]
  lcf_trace_calls("/home/lcom/labs/lab3/trace.txt");

  // enables to save the output of printf function calls on a file
  // [comment this out if you don't want/need it]
  lcf_log_output("/home/lcom/labs/lab3/output.txt");

  // handles control over to LCF
  // [LCF handles command line arguments and invokes the right function]
  if (lcf_start(argc, argv))
    return 1;

  // LCF clean up tasks
  // [must be the last statement before return]
  lcf_cleanup();

  return 0;
}

int(kbd_test_scan)() {

  int ipc_status;
  message msg;
  int r;
  uint8_t bit_no = 1;

  if (kbd_subscribe_int(&bit_no)) {
    printf("Error subscribing");
    return 1;
  }

  uint32_t irq_set = BIT(bit_no);

  while (code != ESC) {
    /* Get a request message. */
    if ((r = driver_receive(ANY, &msg, &ipc_status)) != 0) {
      printf("driver_receive failed with: %d", r);
      continue;
    }
    if (is_ipc_notify(ipc_status)) { /* received notification */
      switch (_ENDPOINT_P(msg.m_source)) {
        case HARDWARE:                             /* hardware interrupt notification */
          if (msg.m_notify.interrupts & irq_set) { /* subscribed interrupt */

            kbc_ih();

            if (kbd_err == 0) {
              if (two_byte == 1) {
                if (code != TWO_B_LONG) {
                  two_byte = 0;
                  uint8_t data[2] = {TWO_B_LONG, code};
                  if (kbd_print_scancode(!(code & MSB), 2, data))
                    return 1;
                }
              }

              else {
                uint8_t data[1] = {code};

                if (kbd_print_scancode(!(code & MSB), 1, data)) {
                  return 1;
                }
              }
            }
          }
          break;
        default:
          break; /* no other notifications expected: do nothing */
      }
    }
    else { /* received a standard message, not a notification */
           /* no standard messages expected: do nothing */
    }
  }

  kbd_err = 0;

  if (kbd_unsubscribe_int()) {
    printf("Error unsubscribing");
    return 1;
  }

  if (kbd_print_no_sysinb(count)) {
    printf("Error printing the number of sys_inb calls\n");
    return 1;
  }

  count = 0;
  return 0;
}

int(kbd_test_poll)() {
  while (code != ESC) {
    kbc_ih_poll();
    if (isobf == 1) {
      if (two_byte == 1) {

        uint8_t data[2] = {TWO_B_LONG, code};
        if (kbd_print_scancode(!(code & MSB), 2, data))
          return 1;
      }

      else {
        uint8_t data[1] = {code};

        if (kbd_print_scancode(!(code & MSB), 1, data)) {
          return 1;
        }
      }
    }
  }

  isobf = 0;
  if (kbd_print_no_sysinb(count)) {
    printf("Error printing number of sys_inb calls\n");
    return 1;
  }

  if (kbd_int_enable()) { // if the input buffer is full it wont enable interuptions
    printf("Error enabling interuptions\n");
    return 1;
  }

  count = 0; // reset global count variable

  return 0;
}

int(kbd_test_timed_scan)(uint8_t n) {
  if (n < 0) {
    printf("Invalid number of seconds\n");
    return 1;
  }

  int sec = 0;
  int ipc_status;
  message msg;
  int r;
  uint8_t bit_no_kbd = 1;
  uint8_t bit_no_timer = 0;

  if (kbd_subscribe_int(&bit_no_kbd)) {
    printf("Error subscribing");
    return 1;
  }

  if (timer_subscribe_int(&bit_no_timer)) {
    printf("Error subscribing");
    return 1;
  }

  uint32_t irq_set_kbd = BIT(bit_no_kbd);
  uint32_t irq_set_timer = BIT(bit_no_timer);

  while ((code != ESC) && (sec < n)) {
    /* Get a request message. */
    if ((r = driver_receive(ANY, &msg, &ipc_status)) != 0) {
      printf("driver_receive failed with: %d", r);
      continue;
    }
    if (is_ipc_notify(ipc_status)) { /* received notification */
      switch (_ENDPOINT_P(msg.m_source)) {
        case HARDWARE:
          if (msg.m_notify.interrupts & irq_set_timer) {
            timer_int_handler();
            if (!(counter % sys_hz())) { // each time a second passes
              sec++;
            }
          }
          if (msg.m_notify.interrupts & irq_set_kbd) {

            kbc_ih();

            if (kbd_err == 0) {
              if (two_byte == 1) {
                if (code != TWO_B_LONG) {
                  two_byte = 0;
                  uint8_t data[2] = {TWO_B_LONG, code};
                  if (kbd_print_scancode(!(code & MSB), 2, data))
                    return 1;
                }
              }

              else {
                uint8_t data[1] = {code};

                if (kbd_print_scancode(!(code & MSB), 1, data)) {
                  return 1;
                }
              }
              counter = 0;
              sec = 0;
            }
          }
          break;
        default:
          break; /* no other notifications expected: do nothing */
      }
    }
    else { /* received a standard message, not a notification */
           /* no standard messages expected: do nothing */
    }
  }

  kbd_err = 0;

  if (kbd_unsubscribe_int()) {
    printf("Error unsubscribing Keyboard");
    return 1;
  }
  if (timer_unsubscribe_int()) {
    printf("Error unsubscribing timer");
    return 1;
  }

  if (kbd_print_no_sysinb(count)) {
    printf("Error printing the number of sys_inb calls\n");
    return 1;
  }

  count = 0;
  return 0;
}
