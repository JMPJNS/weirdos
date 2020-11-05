#!/bin/bash

cd src
nasm s2/extended_space.asm -f bin -o ../bin/extended_space.bin
nasm s1/bootloader.asm -f bin -o ../bin/bootloader.bin

cat ../bin/bootloader.bin ../bin/extended_space.bin > ../out/weirdos.flp
