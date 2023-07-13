UNAME_S := $(shell uname -s)

sandboot: src/boot.asm
	nasm -f bin src/boot.asm -o bin/boot.bin

run: sandboot
	qemu-system-x86_64 bin/boot.bin

flash: sandboot
ifeq ($(UNAME_S),Darwin)
	diskutil unmountDisk /dev/$(USB)
endif
	sudo dd if=bin/boot.bin of=/dev/$(USB) bs=512
