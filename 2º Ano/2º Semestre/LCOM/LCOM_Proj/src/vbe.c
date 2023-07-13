#include "vbe.h"
#include "xpm/xpm.h"

uint16_t get_h_res() { return hres; }
uint16_t get_v_res() { return vres; }

int(set_mode)(uint16_t mode) {
  reg86_t r;
  memset(&r, 0, sizeof(r));
  r.ax = VBE_MODE;
  r.bx = LINEAR | mode;
  r.intno = VBE_INT;

  if (sys_int86(&r) != OK) {
    printf("set_vbe_mode: sys_int86() failed\n");
    return 1;
  }
  return 0;
}

int(mapmem)(uint16_t mode) {
  vbe_mode_info_t vmi;

  if (vbe_get_mode_info(mode, &vmi) != 0)
    return 1;

  hres = vmi.XResolution;
  vres = vmi.YResolution;
  vmi_info = vmi;
  bytesPerPixel = vmi.BytesPerScanLine / hres;

  int r;
  struct minix_mem_range mr;
  unsigned int vram_base = vmi.PhysBasePtr;
  unsigned int vram_size = hres * vres * bytesPerPixel;

  mr.mr_base = (phys_bytes) vram_base;
  mr.mr_limit = mr.mr_base + vram_size;
  if (OK != (r = sys_privctl(SELF, SYS_PRIV_ADD_MEM, &mr))) {
    panic("sys_privctl (ADD_MEM) failed: %d\n", r);
  }

  video_mem = vm_map_phys(SELF, (void *) mr.mr_base, vram_size);

  if (video_mem == MAP_FAILED) {
    panic("couldn't map video memory");
  }

  buffer = (uint8_t *) malloc(vram_size);
  background = (uint8_t *) malloc(vram_size);

  return 0;
}

int(vg_draw_pixel)(uint32_t color, uint16_t x, uint16_t y) {
  char *ptr;
  ptr = (char *) buffer + (y * hres + x) * bytesPerPixel;
  memcpy(ptr, &color, bytesPerPixel);
  return 0;
}

int(vg_draw_line)(uint16_t x, uint16_t y, uint16_t len, uint32_t color) {
  for (int i = 0; i < len; i++) {
    vg_draw_pixel(color, x + i, y);
  }
  return 0;
}

int(vg_draw_rectangle)(uint16_t x, uint16_t y, uint16_t width, uint16_t height, uint32_t color) {
  for (int i = 0; i < height; i++) {
    vg_draw_line(x, y + i, width, color);
  }
  return 0;
}

int(vg_draw_rect_pattern)(uint16_t mode, uint8_t no_rectangles, uint32_t first, uint8_t step) {
  uint16_t recX = hres / no_rectangles;
  uint16_t recY = vres / no_rectangles;
  for (int row = 0; row < no_rectangles; row++) {
    for (int col = 0; col < no_rectangles; col++) {
      uint32_t color = 0;
      if (mode == 0x105) {
        color = (first + (row * no_rectangles + col) * step) % (1 << vmi_info.BitsPerPixel);
      }
      vg_draw_rectangle(col * recX, row * recY, recX, recY, color);
    }
  }
  return 0;
}

int(vg_draw_xpm)(xpm_image_t *xpm_image, uint16_t x, uint16_t y) {
  for (int col = 0; col < xpm_image->width; col++) {
    for (int row = 0; row < xpm_image->height; row++) {
      vg_draw_pixel(xpm_image->bytes[row * xpm_image->width + col], x + col, y + row);
    }
  }
  return 0;
}

int(vg_clear_screen)() {
  if (vg_draw_rectangle(0, 0, hres, vres, 0) != 0)
    return 1;
  return 0;
}

void(copyBuffer)() {
  memcpy(video_mem, buffer, hres * vres * bytesPerPixel);
}

void draw_background() {
  memcpy(buffer, background, hres * vres * bytesPerPixel);
}

void load_background() {
  xpm_image_t img;

  xpm_load(background_xpm, XPM_INDEXED, &img);
  vg_draw_xpm(&img, 0, 0);

  memcpy(background, buffer, hres * vres * bytesPerPixel);
}
