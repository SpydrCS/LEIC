#ifndef __MOUSE_H_
#define __MOUSE_H_

#include "i8042.h"
#include "kbd.h"
#include <lcom/lcf.h>
#include <minix/sysutil.h>


/**
 * @brief mouse_subscribe_int
 *
 * @param bit_no pointer to the variable
 * @return int
 */
int mouse_subscribe_int(uint8_t *bit_no);


/**
 * @brief mouse_unsubscribe_int
 *
 * @return int
 */
int mouse_unsubscribe_int();

/**
 * @brief process_packets
 *
 * @param bytes pointer to the variable
 * @return struct packet
 */
struct packet process_packets(uint8_t *bytes);


/**
 * @brief kbc_read_status
 *
 * @param status pointer to the variable
 * @return int
 */
int(kbc_read_status)(uint8_t *status);


/**
 * @brief kbc_read_buffer
 *
 * @param data pointer to the variable
 * @return int
 */
int(kbc_read_buffer)(uint8_t *data);

/**
 * @brief kbc_check_out_buf
 *
 * @return int
 */
int(kbc_check_out_buf)();

/**
 * @brief mouse_ih
 *
 * @return void
 */
void(mouse_ih)();


/**
 * @brief mouse_get_event
 *
 * @param pk pointer to the variable
 * @return struct mouse_ev
 */
struct mouse_ev *mouse_get_event(struct packet *pk);

#endif
