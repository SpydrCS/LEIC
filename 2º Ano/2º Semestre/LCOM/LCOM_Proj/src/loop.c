#include "loop.h"
#include "kbd.h"
#include "kbd_event.h"
#include "logic.h"
#include "mouse.h"
#include "vbe.h"

#include <lcom/lcf.h>

// static bitmasks
static uint8_t bitmask_kbd;
static uint8_t bitmask_timer;
static uint8_t mouse_bitmask;

extern uint8_t data;

void game_start() {
  if (mapmem(VBE_MODE_105) != 0)
    return;
  if (set_mode(VBE_MODE_105) != 0)
    return;

  timer_subscribe_int(&bitmask_timer);
  kbd_subscribe_int(&bitmask_kbd);
  mouse_subscribe_int(&mouse_bitmask);

  initialize_game();
  initialize_menu();
  update_game_state(main_menu);
}

void game_loop() {

  int loop_stop = 0;
  int ipc_status;
  message msg;
  int r;

  struct packet pk;
  struct mouse_ev *evt;
  uint8_t size = 0; // size of the array of the packets
  uint8_t bytes[3]; // array with the bytes of the packets

  while (!loop_stop) {

    if ((r = driver_receive(ANY, &msg, &ipc_status)) != 0) {
      printf("driver_receive failed with: %d", r);
      continue;
    }
    if (is_ipc_notify(ipc_status)) {
      switch (_ENDPOINT_P(msg.m_source)) {
        case HARDWARE:
          if (msg.m_notify.interrupts & bitmask_kbd) {
            kbd_event event;
            if (kbd_game_event_handler(&event) == 0) {
              if (kbd_logic(&event) == 1)
                loop_stop = 1;
            }
          }
          if (msg.m_notify.interrupts & mouse_bitmask) {
            mouse_ih();
            if (size == 0 && (data & BIT(3)) == 0) { // checks if in sync
              continue;
            }
            else { // checks if the array doesn't contain all the bytes of the packet
              bytes[size] = data;
              size++;
            }

            if (size == 3) { // checks if the array has all the bytes from the packet
              pk = process_packets(bytes);
              size = 0;

              evt = mouse_get_event(&pk);

              if (mouse_logic(evt))
                loop_stop = 1;
            }
            mouse_get_event(&pk);
          }

          if (msg.m_notify.interrupts & bitmask_timer) {
            if (timer_logic() == 1) {
              loop_stop = 1;
            }
          }

          break;

        default:
          break;
      }
    }
    else {
    }
  }
  return;
}

void game_end() {

  if (timer_unsubscribe_int() != 0) {
    printf("error unsubscribing timer\n");
  }
  if (kbd_unsubscribe_int() != 0) {
    printf("error unsubscribing keyboard\n");
  }
  if (vg_exit() != 0) {
    printf("error unsubscribing video\n");
  }
}
