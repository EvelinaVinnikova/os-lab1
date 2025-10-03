# Makefile (WSL/Linux)
CC      := gcc
LD      := ld
OBJCOPY := objcopy
NASM    := nasm
QEMU    := qemu-system-i386

CFLAGS  := -m32 -ffreestanding -fno-pic -fno-stack-protector -O2 -Wall -Wextra
LDFLAGS := -m elf_i386 -T link.ld -nostdlib

.PHONY: all run clean
all: disk.img

boot.bin: boot.asm
	$(NASM) -f bin $< -o $@

kernel.o: kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel.elf: kernel.o
	$(LD) $(LDFLAGS) -o $@ $<

kernel.bin: kernel.elf
	$(OBJCOPY) -O binary $< $@

disk.img: boot.bin kernel.bin
	dd if=/dev/zero of=$@ bs=1M count=1
	dd if=boot.bin   of=$@ conv=notrunc
	dd if=kernel.bin of=$@ bs=512 seek=1 conv=notrunc

run: disk.img
	$(QEMU) -drive file=$<,format=raw -no-reboot -no-shutdown

clean:
	rm -f *.o *.elf *.bin disk.img