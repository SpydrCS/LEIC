#ifndef _LCOM_I8042_H_
#define _LCOM_I8042_H_

#include <lcom/lcf.h>

/** @defgroup i8042 i8042
 * @{
 *
 * Constants for programming the i8042 Keyboard. Needs to be completed.
 */

#define IRQ1_KEYBOARD 1
#define MOUSE_IRQ 12

#define WAIT_KBC 20000

#define KBC_ST_REG 0x64
#define KBC_CMD_REG 0x64
#define KBC_OUT_BUF 0x60
#define KBC_IN_BUF 0x60

#define PAR_ERR BIT(7)     // Parity error - invalid data
#define TIMEOUT_ERR BIT(6) // Timeout error - invalid data
#define AUX BIT(5)         // Mouse data
#define INH BIT(4)         // Inhibit flag: 0 if keyboard is inhibited
#define A2 BIT(3)          // A2 input line: irrelevant for LCOM
#define SYS BIT(2)         // System flag: irrelevant for LCOM
#define IBF BIT(1)         // Input buffer full don’t write commands or arguments
#define OBF BIT(0)         // Output buffer full - data available for reading

#define MSB BIT(7)
#define TWO_B_LONG 0xE0
#define ESC 0x81

#define KBD_PARITY_ERROR BIT(7)
#define KBD_TIMEOUT_ERROR BIT(6)
#define KBD_INPUT_BUFFER_FULL BIT(1)
#define KBD_OUTPUT_BUFFER_FULL BIT(0)

#define RD_COM 0x20
#define WR_COM 0x60
#define SELF_TEST 0xAA
#define INT_TEST 0xAB
#define DIS_KBD_COM 0xAD
#define EN_KBD_COM 0xAE

#define DIS_MOUSE BIT(5)
#define DIS_KBD BIT(4)
#define EN_INT_MOUSE BIT(1)
#define EN_INT_KBD BIT(0)

#define W_MAKE 0x11
#define A_MAKE 0x1E
#define D_MAKE 0x20
#define S_MAKE 0x1F
#define UP_MAKE 0x48
#define DOWN_MAKE 0x50

// breakcodes

#define W_BREAK 0x91
#define A_BREAK 0x9E
#define D_BREAK 0x90
#define S_BREAK 0x9F

#define UP_BREAK 0xC8
#define DOWN_BREAK 0xD0

#define ENTER_MAKE 0x1C
#define ENTER_BREAK 0x9C

#define MOUSE_LB_CLICK BIT(0)
#define MOUSE_RB_CLICK BIT(1)
#define MOUSE_MB_CLICK BIT(2)

#define MOUSE_X_SIGN BIT(4)
#define MOUSE_Y_SIGN BIT(5)

#define MOUSE_X_OVFL BIT(6)
#define MOUSE_Y_OVFL BIT(7)

#endif /* _LCOM_I8042_H */
