#!/bin/bash

cd src

# Build Bootloader
nasm s1/bootloader.asm -f bin -o ../bin/bootloader.bin

# Build assembly stuff
nasm s2/extended_space.asm -f elf64 -o ../bin/extended_space.o

# Build rust stuff
rustc --crate-type=lib --emit obj -o ../bin/kernel.o s3/kernel.rs

# Link
cd ../
ld -o bin/kernel.tmp -Ttext 0x7e00 bin/extended_space.o bin/kernel.o
objcopy -O binary bin/kernel.tmp bin/kernel.bin

cat bin/bootloader.bin bin/kernel.bin > out/weirdos.flp
