#pragma once
#ifndef _LCOM_KBD_H_
#  define _LCOM_KBD_H_

#  include "kbd_event.h"
#  include <lcom/lcf.h>

#  ifdef LAB3
int util_sys_inb_cnt(int port, uint8_t *value);
#  else
#    define util_sys_inb_cnt(p, v) util_sys_inb(p, v)
#  endif

/**
 * @brief kbd subscribe int
 *
 * @param irq_bitmask pointer to the variable
 * @return int
 */
int(kbd_subscribe_int)(uint8_t *irq_bitmask);

/**
 * @brief kbd unsubscribe int
 *
 * @return int
 */
int(kbd_unsubscribe_int)();

/**
 * @brief kbc ih
 *
 * @return void
 */
void(kbc_ih)(void);


/**
 * @brief kbc ih poll
 *
 * @return void
 */
void(kbc_ih_poll)(void);


/**
 * @brief kbd_int_enable
 *
 * @return void
 */
int(kbd_int_enable)();


/**
 * @brief kbc_command_handler
 * @param reg int
 * @param command uint8_t
 * @return void
 */
int(kbc_command_handler)(int reg, uint8_t command);


/**
 * @brief kbc ih
 * @param p pointer to the variable
 * @return void
 */
int kbd_game_event_handler(kbd_event *p);

#endif
