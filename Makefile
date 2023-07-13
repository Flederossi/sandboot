sandboot: src/boot.asm
	nasm -f bin src/boot.asm -o bin/boot.bin

run: sandboot
	qemu-system-x86_64 bin/boot.bin

flash: sandboot
	sudo dd if=bin/boot.bin of=/dev/$(USB) bs=512

iso: sandboot
	mkisofs -o sandboot.iso -b boot.bin -no-emul-boot -boot-load-size 4 -boot-info-table bin/
