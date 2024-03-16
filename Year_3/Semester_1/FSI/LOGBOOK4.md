# Environment Variable andSet-UIDProgram Lab

##  2 - Lab Tassks

### 2.2 - Step 1

After analyzing the output, it seems to be very similar, if not identical, to what is outputted if you type "printenv" or "env" in a shell.

### 2.2 - Step 2

The output seems to be the same as the child environment, and after typing "diff file1 file2" in the shell, nothing showed up, confirming that the files are identical.

#### 2.2 - Step 3

As the outputs are the same, we conclude that the environments of both parent and child are also the same, so we can confirm that he parent’s environment variables are inherited by the child process.

### 2.3 - Step 1

Nothing is printed, so there is no environment.

### 2.3 - Step 2

The environment variables are printed.

### 2.3 - Step 3

We can conclude that the program gets its environment variables from external locations, as we can see with the line "extern char **environ;", which could result in an attack if the attacker has access to the envirnoment itself.

### 2.5  - Step 3

After running the code, the variables I created did not get into the SET-UID child process.

### 2.6

No, we can't run our malicious code as the enviromeent variables in SET_UID do not get into child processes.

#### 2.7 - Step 2

- Regular program, regular user: runs mylib.c instead of myprog.c
- SET-UID root program, regular user: runs myprog.c as intended
- SET-UID root program, regular user with exported environment variable: runs myprog.c as intended
- SET-UID user1 program, non-root user with exported environment variable: runs mylib.c instead of myprog.c
