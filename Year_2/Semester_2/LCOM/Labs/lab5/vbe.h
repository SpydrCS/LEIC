#pragma once

#include <lcom/lcf.h>
#include <minix/type.h>
#include <stdint.h>

#pragma pack(1)

#pragma options align = reset

typedef uint8_t BCD;

#define AH 0x4F
#define VBE_MODE 0x4F02
#define VBE_INT 0x10
#define LINEAR 1 << 14

static uint16_t hres;
static uint16_t vres;
static vbe_mode_info_t vmi_info;
static uint8_t bytesPerPixel;
static void *video_mem;
static void *buffer;

int(set_mode)(uint16_t mode);
int(mapmem)(uint16_t mode);
int(vg_draw_pixel)(uint32_t color, uint16_t x, uint16_t y);
int(vg_draw_line)(uint16_t x, uint16_t y, uint16_t len, uint32_t color);
int(vg_draw_rectangle)(uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint32_t color);
int(vg_draw_rect_pattern)(uint16_t mode, uint8_t no_rectangles, uint32_t first, uint8_t step);
int(vg_draw_xpm)(xpm_image_t *xpm_image, uint16_t x, uint16_t y);
int8_t(getRed)(uint32_t first, uint8_t step, int col);
int8_t(getGreen)(uint32_t first, uint8_t step, int row);
int8_t(getBlue)(uint32_t first, uint8_t step, int col, int row);
int8_t(getSize)(uint8_t mask);
int(vg_clear_screen)();
void(copyBuffer)();
