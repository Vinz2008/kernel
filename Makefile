CC=i686-elf-gcc
AS=i686-elf-as

OBJS=\
kernel.o \
boot.o \

all: kernel.iso

kernel.iso: kernel.bin
	grub-mkrescue -o $@ isodir

kernel.bin: $(OBJS)
	$(CC) -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $^ -lgcc
	cp kernel.bin isodir/boot

%.o: %.c
	$(CC) -c $^ -o $@ -std=gnu99 -ffreestanding -O2 -Wall -Wextra

%.o: %.s
	$(AS) -c $^ -o $@

clean:
	rm -f $(OBJS)
	rm -f kernel.bin
	rm -f kernel.iso

qemu:
	qemu-system-i386 -cdrom kernel.iso
