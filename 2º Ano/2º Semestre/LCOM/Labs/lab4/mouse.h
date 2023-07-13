#ifndef __MOUSE_H_
#define __MOUSE_H_

#include "i8042.h"
#include "kbc.h"
#include <lcom/lcf.h>
#include <minix/sysutil.h>

int mouse_subscribe_int(uint8_t *bit_no);

int mouse_unsubscribe_int();

struct packet process_packets(uint8_t *bytes);

int mouse_disable_reporting();

int(kbc_read_status)(uint8_t *status);

int(kbc_check_in_buf)();

int(kbc_read_buffer)(uint8_t *data);

void(mouse_ih)();

#endif
