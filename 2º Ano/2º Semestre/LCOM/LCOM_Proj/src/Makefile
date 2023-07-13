# name of the program (Minix service)
PROG=proj

# source code files to be compiled
SRCS = game.c kbd.c vbe.c timer.c loop.c snake.c logic.c proj.c utils.c apple.c menu.c mouse.c cursor.c

# additional compilation flags
# "-Wall -Wextra -Werror -I . -std=c11 -Wno-unused-parameter" are already set

# list of library dependencies (for Lab 5, only LCF library)
CPPFLAGS += -pedantic #-D __LCOM_OPTIMIZED__

DPADD += ${LIBLCF}
LDADD += -llcf

# include LCOM's makefile that does all the "heavy lifting"
.include <minix.lcom.mk>
