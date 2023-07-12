sandboot: src/boot.asm
	nasm -f bin src/boot.asm -o bin/boot.bin
run: sandboot
	qemu-system-x86_64 bin/boot.bin
