sandboot: src/boot.asm
	nasm -f bin src/boot.asm -o bin/boot.bin
run: sandboot
	qemu-system-x86_64 bin/boot.bin
flash: sandboot
	sudo dd if=bin/boot.bin of=/dev/$(USB) bs=512
iso: sandboot
	genisoimage -quiet -V sandboot -input-charset iso8859-1 -o sandboot.iso -b bin/boot.bin
