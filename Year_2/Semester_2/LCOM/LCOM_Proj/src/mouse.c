
#include <mouse.h>

int mouse_hookID = 2; // hook_id used for the mouse
uint8_t data;

int mouse_subscribe_int(uint8_t *bit_no) {
  *bit_no = BIT(mouse_hookID);
  if (sys_irqsetpolicy(MOUSE_IRQ, IRQ_REENABLE | IRQ_EXCLUSIVE, &mouse_hookID) != 0) {
    printf("%s sys_irqsetpolicy() failed \n", __func__);
    return 1;
  }
  return 0;
}

int mouse_unsubscribe_int() {
  if (sys_irqrmpolicy(&mouse_hookID) != 0) {
    printf("%s: sys_irqrmpolicy() failed\n", __func__);
    return 1;
  }
  return 0;
}

struct packet process_packets(uint8_t *bytes) {
  struct packet pp;

  for (int i = 0; i < 3; ++i) pp.bytes[i] = bytes[i];

  pp.lb = bytes[0] & MOUSE_LB_CLICK; // bit 0
  pp.rb = bytes[0] & MOUSE_RB_CLICK; // bit 1
  pp.mb = bytes[0] & MOUSE_MB_CLICK; // bit 2
  /** BIT 3 is ignored? **/
  pp.x_ov = bytes[0] & MOUSE_X_OVFL; // bit 6
  pp.y_ov = bytes[0] & MOUSE_Y_OVFL; // bit 7

  pp.delta_x = bytes[1];
  pp.delta_y = bytes[2];

  /** Special to convert argument to complement of 2, depending on the sign of X and Y **/
  bool msb_x = bytes[0] & MOUSE_X_SIGN;
  bool msb_y = bytes[0] & MOUSE_Y_SIGN;
  for (int i = 8; i < 16; ++i) pp.delta_x += (msb_x << i);
  for (int i = 8; i < 16; ++i) pp.delta_y += (msb_y << i);

  return pp;
}

int(kbc_read_status)(uint8_t *status) {
  // temporary variable to save what's read from the status register

  if (util_sys_inb(KBC_ST_REG, status) != OK) {
    printf("kbc_read_status::Error using sys_inb\n");
    return 1;
  }

  // status is a return argument which contains the status byte
  return 0;
}

int(kbc_check_in_buf)() {
  uint8_t status; // temporary variable for status

  // first reads the status register
  if (kbc_read_status(&status) != 0) {
    printf("kbc_check_out_buf::Error reading status\n");
    return 1;
  }

  // checks if the ouput buffer has data to read
  if (status & KBD_OUTPUT_BUFFER_FULL) {
    // checks if the data is valid (i.e. if there are no errors)
    if ((status & (KBD_PARITY_ERROR | KBD_TIMEOUT_ERROR)) == 0) {
      return 1;
    }
    else {
      return 0; // data has errors
    }
  }
  else
    return 0; // no data to read
}

int(kbc_read_buffer)(uint8_t *data) {

  if (util_sys_inb(KBC_OUT_BUF, data) != 0) {
    printf("kbc_read_buffer::Error using sys_inb\n");
    return 1;
  }

  return 0;
}

int(kbc_check_out_buf)() {
  uint8_t status; // temporary variable for status

  // first reads the status register
  if (kbc_read_status(&status) != OK) {
    printf("kbc_check_out_buf::Error reading status\n");
    return 1;
  }

  // checks if the ouput buffer has data to read
  if (status & KBC_OUT_BUF) {
    // checks if the data is valid (i.e. if there are no errors)
    if ((status & (KBD_PARITY_ERROR | KBD_TIMEOUT_ERROR)) == 0) {
      return 1;
    }
    else {
      return 0; // data has errors
    }
  }
  else
    return 0; // no data to read
}

// mouse interrupt handler
void(mouse_ih)() {
  if (kbc_check_out_buf()) {
    kbc_read_buffer(&data);
  }
}

struct mouse_ev *mouse_get_event(struct packet *pk) {
  static struct packet oldpk; // storing the previous packet for comparison
  static struct mouse_ev event;
  static bool first = true;

  uint8_t temp = pk->bytes[0];

  if (first) {
    event.type = BUTTON_EV;
    first = false;
  }
  else {
    if ((temp & MOUSE_LB_CLICK) == MOUSE_LB_CLICK && ((oldpk.bytes[0] & MOUSE_LB_CLICK) == 0)) {
      event.type = LB_PRESSED;
    }
    else if ((temp & MOUSE_RB_CLICK) == MOUSE_RB_CLICK && ((oldpk.bytes[0] & MOUSE_RB_CLICK) == 0)) {
      event.type = RB_PRESSED;
    }
    else if ((temp & MOUSE_MB_CLICK) == MOUSE_MB_CLICK && ((oldpk.bytes[0] & MOUSE_MB_CLICK) == 0)) {
      event.type = BUTTON_EV;
    }
    else if (((temp & MOUSE_LB_CLICK) == 0) && ((oldpk.bytes[0] & MOUSE_LB_CLICK) == MOUSE_LB_CLICK)) {
      event.type = LB_RELEASED;
    }
    else if (((temp & MOUSE_RB_CLICK) == 0) && ((oldpk.bytes[0] & MOUSE_RB_CLICK) == MOUSE_RB_CLICK)) {
      event.type = RB_RELEASED;
    }
    else if (((temp & MOUSE_MB_CLICK) == 0) && ((oldpk.bytes[0] & MOUSE_MB_CLICK) == MOUSE_MB_CLICK)) {
      event.type = BUTTON_EV;
    }
    else if (pk->bytes[1] != 0 || pk->bytes[2] != 0) {
      event.type = MOUSE_MOV;
      event.delta_x = pk->delta_x;
      event.delta_y = pk->delta_y;
    }
  }

  oldpk = *pk;
  return &event;
}
