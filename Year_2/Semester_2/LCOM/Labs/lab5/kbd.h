#pragma once
#ifndef _LCOM_KBD_H_
#  define _LCOM_KBD_H_

#  include <lcom/lcf.h>

#  ifdef LAB3
int util_sys_inb_cnt(int port, uint8_t *value);
#  else
#    define util_sys_inb_cnt(p, v) util_sys_inb(p, v)
#  endif

int(kbd_subscribe_int)(uint8_t *bit_no);

int(kbd_unsubscribe_int)();

void(kbc_ih)(void);

void(kbc_ih_poll)(void);

int(kbd_int_enable)();

int(kbc_command_handler)(int reg, uint8_t command);

#endif
