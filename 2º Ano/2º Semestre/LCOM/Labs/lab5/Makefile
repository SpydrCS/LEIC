# name of the program (Minix service)
PROG=lab5 

# source code files to be compiled
SRCS = lab5.c kbd.c utils.c timer.c vbe.c

# additional compilation flags
# "-Wall -Wextra -Werror -I . -std=c11 -Wno-unused-parameter" are already set
# list of library dependencies (for Lab 5, only LCF library)
CPPFLAGS += -pedantic -DLAB5
CPPFLAGS += -D LAB5

DPADD += ${LIBLCF} ${LIBLM}
LDADD += -llcf -llm
# include LCOM's makefile that does all the "heavy lifting"
.include <minix.lcom.mk>
