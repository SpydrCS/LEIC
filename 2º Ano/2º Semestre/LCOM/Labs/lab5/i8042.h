#ifndef _LCOM_I8042_H_
#define _LCOM_I8042_H_

#include <lcom/lcf.h>

/** @defgroup i8042 i8042
 * @{
 *
 * Constants for programming the i8042 Keyboard. Needs to be completed.
 */

#define IRQ1_KEYBOARD 1
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

#endif /* _LCOM_I8042_H */
