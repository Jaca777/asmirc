# asmirc
IRC client written in nasm (x86-64). Works on 64 bit linux.

Building
===
```
nasm main.nasm -f elf64 && nasm textio.nasm -f elf64 && gcc -o asmirc main.o textio.o -lc
```


