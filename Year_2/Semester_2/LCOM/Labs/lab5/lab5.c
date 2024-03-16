// IMPORTANT: you must include the following line in all you_r C files
#include <lcom/lcf.h>

#include <lcom/lab5.h>

#include "i8042.h"
#include "i8254.h"
#include "kbd.h"
#include "vbe.h"
#include "xpm/coin.xpm"
#include "xpm/extra/background.XPM"
#include "xpm/extra/dash.xpm"
#include "xpm/extra/snake_left.xpm"
#include "xpm/extra/snake_right.xpm"
#include "xpm/extra/title.xpm"
#include "xpm/extra/two_points.xpm"
#include "xpm/letters/a.xpm"
#include "xpm/letters/b.xpm"
#include "xpm/letters/c.xpm"
#include "xpm/letters/d.xpm"
#include "xpm/letters/e.xpm"
#include "xpm/letters/f.xpm"
#include "xpm/letters/g.xpm"
#include "xpm/letters/h.xpm"
#include "xpm/letters/i.xpm"
#include "xpm/letters/j.xpm"
#include "xpm/letters/k.xpm"
#include "xpm/letters/l.xpm"
#include "xpm/letters/m.xpm"
#include "xpm/letters/n.xpm"
#include "xpm/letters/o.xpm"
#include "xpm/letters/p.xpm"
#include "xpm/letters/q.xpm"
#include "xpm/letters/r.xpm"
#include "xpm/letters/s.xpm"
#include "xpm/letters/t.xpm"
#include "xpm/letters/u.xpm"
#include "xpm/letters/v.xpm"
#include "xpm/letters/w.xpm"
#include "xpm/letters/x.xpm"
#include "xpm/letters/y.xpm"
#include "xpm/letters/z.xpm"
#include "xpm/numbers/eight.xpm"
#include "xpm/numbers/five.xpm"
#include "xpm/numbers/four.xpm"
#include "xpm/numbers/nine.xpm"
#include "xpm/numbers/one.xpm"
#include "xpm/numbers/seven.xpm"
#include "xpm/numbers/six.xpm"
#include "xpm/numbers/three.xpm"
#include "xpm/numbers/two.xpm"
#include "xpm/numbers/zero.xpm"
#include <lcom/timer.h>
#include <minix/sysutil.h>
#include <stdint.h>
#include <stdio.h>

int hookID = 1;
int hook_id = 0;
int kbd_err = 0;
uint8_t code = 0;
int two_byte = 0;
int count = 0;
int isobf = 0; // is output buffer full
int counter = 0;
bool finished = false;

// Any header files included below this line should have been created by you

int main(int argc, char *argv[]) {
  // sets the language of LCF messages (can be either EN-US or PT-PT)
  lcf_set_language("EN-US");

  // enables to log function invocations that are being "wrapped" by LCF
  // [comment this out if you don't want/need it]
  lcf_trace_calls("/home/lcom/labs/lab5/trace.txt");

  // enables to save the output of printf function calls on a file
  // [comment this out if you don't want/need it]
  lcf_log_output("/home/lcom/labs/lab5/output.txt");

  // handles control over to LCF
  // [LCF handles command line arguments and invokes the right function]
  if (lcf_start(argc, argv))
    return 1;

  // LCF clean up tasks
  // [must be the last statement before return]
  lcf_cleanup();

  return 0;
}

int(video_test_init)(uint16_t mode, uint8_t delay) {
  if (set_mode(mode) != 0)
    return 1;

  sleep(delay);

  if (vg_exit() != 0)
    return 1;
  return 0;
}

int(video_test_rectangle)(uint16_t mode, uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint32_t color) {
  if (mapmem(mode) != 0)
    return 1;
  if (set_mode(mode) != 0)
    return 1;
  if (vg_draw_rectangle(x, y, width, height, color))
    return 1;

  int ipc_status;
  message msg;
  uint8_t bit_no_kbd = 1;
  kbd_subscribe_int(&bit_no_kbd); // adicionar

  uint32_t irq_set_kbd = BIT(bit_no_kbd);
  int r; // adicionar

  while (code != ESC) { // mudar
    if ((r = driver_receive(ANY, &msg, &ipc_status)) != 0) {
      printf("failed");
      continue;
    }
    if (is_ipc_notify(ipc_status)) {
      switch (_ENDPOINT_P(msg.m_source)) {
        case HARDWARE:
          if (msg.m_notify.interrupts & irq_set_kbd) { // meter BIT()
            kbc_ih();
          }
          break;
        default:
          break;
      }
    }
  }

  if (kbd_unsubscribe_int()) {
    printf("Error unsubscribing Keyboard");
    return 1;
  }
  if (vg_exit() != 0)
    return 1;

  return 0;
}

int(video_test_pattern)(uint16_t mode, uint8_t no_rectangles, uint32_t first, uint8_t step) {
  if (mapmem(mode) != 0)
    return 1;
  if (set_mode(mode) != 0)
    return 1;
  if (vg_draw_rect_pattern(mode, no_rectangles, first, step) != 0)
    return 1;

  int ipc_status;
  message msg;
  uint8_t bit_no_kbd = 1;
  kbd_subscribe_int(&bit_no_kbd); // adicionar

  uint32_t irq_set_kbd = BIT(bit_no_kbd);
  int r; // adicionar

  while (code != ESC) { // mudar
    if ((r = driver_receive(ANY, &msg, &ipc_status)) != 0) {
      printf("failed");
      continue;
    }
    if (is_ipc_notify(ipc_status)) {
      switch (_ENDPOINT_P(msg.m_source)) {
        case HARDWARE:
          if (msg.m_notify.interrupts & irq_set_kbd) { // meter BIT()
            kbc_ih();                                  // adicionar
          }
          break;
      }
    }
  }

  if (kbd_unsubscribe_int()) {
    printf("Error unsubscribing Keyboard");
    return 1;
  }
  if (vg_exit() != 0)
    return 1;
  return 0;
}

int(video_test_xpm)(xpm_map_t xpm, uint16_t x, uint16_t y) {
  uint16_t mode = 0x105;
  xpm_image_t img;
  if (mapmem(mode) != 0)
    return 1;
  if (set_mode(mode) != 0)
    return 1;

  xpm_load(background, XPM_INDEXED, &img);

  if (vg_draw_xpm(&img, x, y) != 0)
    return 1;

  int ipc_status;
  message msg;
  uint8_t bit_no_kbd = 1;
  kbd_subscribe_int(&bit_no_kbd); // adicionar

  uint32_t irq_set_kbd = BIT(bit_no_kbd);
  int r; // adicionar

  while (code != ESC) { // mudar
    if ((r = driver_receive(ANY, &msg, &ipc_status)) != 0) {
      printf("failed");
      continue;
    }
    if (is_ipc_notify(ipc_status)) {
      switch (_ENDPOINT_P(msg.m_source)) {
        case HARDWARE:
          if (msg.m_notify.interrupts & irq_set_kbd) { // meter BIT()
            kbc_ih();                                  // adicionar
          }
          break;
      }
    }
  }

  if (kbd_unsubscribe_int()) {
    printf("Error unsubscribing Keyboard");
    return 1;
  }

  if (vg_exit() != 0)
    return 1;

  return 0;
}

int(video_test_move)(xpm_map_t xpm, uint16_t xi, uint16_t yi, uint16_t xf, uint16_t yf,
                     int16_t speed, uint8_t fr_rate) {

  uint16_t mode = 0x105;
  xpm_image_t img;
  if (mapmem(mode) != 0)
    return 1;
  if (set_mode(mode) != 0)
    return 1;

  xpm_load(xpm, XPM_INDEXED, &img);

  if (vg_draw_xpm(&img, xi, yi) != 0)
    return 1;

  int ipc_status;

  message msg;
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
  int r; // adicionar
  bool done = false;

  uint32_t irq_set_kbd = BIT(bit_no_kbd);
  uint32_t irq_set_timer = BIT(bit_no_timer);

  while ((code != ESC)) { // mudar
    if ((r = driver_receive(ANY, &msg, &ipc_status)) != 0) {
      printf("failed");
      continue;
    }
    if (is_ipc_notify(ipc_status)) {
      switch (_ENDPOINT_P(msg.m_source)) {
        case HARDWARE:
          if (msg.m_notify.interrupts & irq_set_kbd) { // meter BIT()
            kbc_ih();                                  // adicionar
          }
          if (msg.m_notify.interrupts & irq_set_timer) {
            timer_int_handler();

            if (done)
              continue;
            else {
              if (speed > 0) {
                if (counter % (60 / fr_rate) != 0)
                  continue;
                if (xi == xf) {
                  if (vg_draw_rectangle(xi, yi, img.width, img.height, 0))
                    return 1;
                  yi += speed;
                  if (yi >= yf)
                    yi = yf;
                  if (vg_draw_xpm(&img, xi, yi) != 0)
                    return 1;
                }
                else {
                  if (xi < xf) {
                    if (vg_draw_rectangle(xi, yi, img.width, img.height, 0))
                      return 1;
                    xi += speed;
                    if (xi >= xf)
                      xi = xf;
                    if (vg_draw_xpm(&img, xi, yi) != 0)
                      return 1;
                  }
                  else {
                    if (vg_draw_rectangle(xi, yi, img.width, img.height, 0))
                      return 1;
                    xi -= speed;
                    if (xi <= xf)
                      xi = xf;
                    if (vg_draw_xpm(&img, xi, yi) != 0)
                      return 1;
                  }
                }
              }
              else if (counter % ((60 / fr_rate) * (-speed)) == 0) {
                if (xi == xf) {
                  if (vg_draw_rectangle(xi, yi, img.width, img.height, 0))
                    return 1;
                  yi++;
                  if (vg_draw_xpm(&img, xi, yi) != 0)
                    return 1;
                }
                else {
                  if (vg_draw_rectangle(xi, yi, img.width, img.height, 0) != 0)
                    return 1;
                  xi++;
                  if (vg_draw_xpm(&img, xi, yi) != 0)
                    return 1;
                }
              }
              if (xi == xf && yi == yf) {
                done = true;
                if (vg_draw_rectangle(xi, yi, img.width, img.height, 0))
                  return 1;
                finished = !finished;
              }
            }
          }
          break;
      }
    }
  }

  if (kbd_unsubscribe_int()) {
    printf("Error unsubscribing Keyboard");
    return 1;
  }

  if (timer_unsubscribe_int()) {
    printf("Error unsubscribing timer");
    return 1;
  }

  if (vg_exit() != 0)
    return 1;

  return 0;
}

int(video_test_snakes)(uint16_t xi1, uint16_t yi1, uint16_t xf1, uint16_t yf1, uint16_t xi2, uint16_t yi2, uint16_t xf2, uint16_t yf2, int16_t speed, uint8_t fr_rate) {

  return 0;
}

int(video_test_controller)() {
  return 0;
}
