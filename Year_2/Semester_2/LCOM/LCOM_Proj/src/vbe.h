#pragma once

#include <lcom/lcf.h>
#include <machine/int86.h>
#include <math.h>
#include <minix/drivers.h>
#include <minix/syslib.h>
#include <minix/type.h>
#include <stdint.h>
#include <sys/mman.h>
#include <sys/types.h>

#pragma pack(1)

#pragma options align = reset

typedef uint8_t BCD;

#define AH 0x4F
#define VBE_MODE 0x4F02
#define VBE_INT 0x10
#define LINEAR 1 << 14

#define VBE_MODE_115 0x115
#define VBE_MODE_105 0x105

static uint16_t hres;
static uint16_t vres;
static vbe_mode_info_t vmi_info;
static uint8_t bytesPerPixel;
static uint8_t *video_mem;
static uint8_t *buffer;
static uint8_t *background;


/**
 * @brief get_h_res
 *
 * @return uint16_t
 */
uint16_t get_h_res();

/**
 * @brief get_v_res
 *
 * @return uint16_t
 */
uint16_t get_v_res();

/**
 * @brief set_mode
 *
 * @param mode 
 * @return int
 */
int(set_mode)(uint16_t mode);

/**
 * @brief mapmem
 *
 * @param mode 
 * @return int
 */
int(mapmem)(uint16_t mode);

/**
 * @brief vg_draw_pixel
 *
 * @param color
 * @param x
 * @param y
 * @return int
 */
int(vg_draw_pixel)(uint32_t color, uint16_t x, uint16_t y);

/**
 * @brief vg_draw_line
 *
 * @param x
 * @param y
 * @param len
 * @param color 
 * @return int
 */
int(vg_draw_line)(uint16_t x, uint16_t y, uint16_t len, uint32_t color);

/**
 * @brief vg_draw_rectangle
 *
 * @param x
 * @param y
 * @param width
 * @param color 
 * @param height
 * @return int
 */
int(vg_draw_rectangle)(uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint32_t color);

/**
 * @brief vg_draw_rect_pattern
 *
 * @param mode 
 * @param no_rectangless
 * @param first
 * @param step
 * @return int
 */
int(vg_draw_rect_pattern)(uint16_t mode, uint8_t no_rectangles, uint32_t first, uint8_t step);

/**
 * @brief vg_draw_xpm
 *
 * @param xpm_image 
 * @param x
 * @param y
 * @return int
 */
int(vg_draw_xpm)(xpm_image_t *xpm_image, uint16_t x, uint16_t y);

/**
 * @brief vg_clear_screen
 *
 * @return int
 */
int(vg_clear_screen)();

/**
 * @brief copyBuffer
 *
 * @return int
 */
void(copyBuffer)();

/**
 * @brief draw_background
 *
 * @return int
 */
void draw_background();

/**
 * @brief load_background
 *
 * @return int
 */
void load_background();
