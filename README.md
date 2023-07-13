# sandboot
A tiny sand simulation inside a x86 bootloader written in assembly.

<br />

![Alt Text](https://github.com/Flederossi/sandboot/blob/main/assets/screen-capture.gif)

<br />

*Note: This bootloader was written to learn more about how bootloaders work. It does not perform any special task other than the simple simulation of sand particles.*

<br />

## Concept
It uses the pretty simple concept of checking the spaces under a sand particle and moving it to one of the blank spaces. The space directly under the particle is checked first, then the the space down left and at the end the space down right.

<br />

## Compile and Run
Before compiling you need to create the folder bin/ inside the root of the project.
```
mkdir bin
```
After that there are three different ways to use sandboot:

<br />

---

### 1.) Use qemu to run sandboot inside your OS
Dependencies: nasm, qemu
> Compile sandboot and run the binary using qemu
```
make run
```
This should open a window booting sandboot.

---
<br />

---

### 2.) Run it on real hardware by flashing it directly to a usb
Dependencies: nasm

*Note: Use this method if you really know what you are doing. This method can result in data loss if used incorrectly!*
> Get the label of the usb (something like sda, sdb, sdc, ...)
```
fdisk -l
```
> Compile and flash sandboot to the usb (replace [label] with the label of your usb, without the square brackets)
```
make flash USB=[label]
```
Now you can reboot your PC and boot from the usb drive.

---
<br />

---

### 3.) Generate and boot from an iso image
Dependencies: nasm, genisoimage
> Compile sandboot and generate the iso image
```
make iso
```
Now you can use programs like [balenaEtcher](https://etcher.balena.io/) to flash the generated iso image in the root of the project onto an usb drive and boot from it.

---
<br />

If you just want to compile sandboot you can use:
```
make
```
The binary file is generated in bin/boot.bin

<br />
## Configuration
There are some constants in [boot.asm](https://github.com/Flederossi/sandboot/blob/main/src/boot.asm) you can configure. After changing these a recompile is required.
