coreboot README
===============

coreboot is a Free Software project aimed at replacing the proprietary
firmware (BIOS/UEFI) found in most computers. coreboot performs the
required hardware initialization to configure the system, then passes
control to a different executable, referred to in coreboot as the
payload. Most often, the primary function of the payload is to boot the
operating system (OS).

With the separation of hardware initialization and later boot logic,
coreboot is perfect for a wide variety of situations. It can be used
for specialized applications that run directly in the firmware, running
operating systems from flash, loading custom bootloaders, or
implementing firmware standards, like PC BIOS services or UEFI. This
flexibility allows coreboot systems to include only the features
necessary in the target application, reducing the amount of code and
flash space required.


CPU Backdoor
-----------



build coreboot
-----------

Step 1 - Install tools and libraries needed for coreboot

Debian based distros: sudo apt-get install -y bison build-essential curl flex git gnat libncurses-dev libssl-dev zlib1g-dev pkgconf

Arch based distros: sudo pacman -S base-devel curl git gcc-ada ncurses zlib

Redhat based distros: sudo dnf install git make gcc-gnat flex bison xz bzip2 gcc g++ ncurses-devel wget zlib-devel patch


Step 2 - Download this coreboot source tree


`````shell
git clone --recursive https://github.com/whensungoesdown/coreboot.git
cd coreboot
`````



Step 3 - Build the coreboot toolchain

`````shell
[coreboot]$ make crossgcc-i386 CPUS=$(nproc)       # build i386 toolchain
`````
or just

`````shell
[coreboot]$ make crossgcc-i386
`````

> Note that the i386 toolchain is currently used for all x86 platforms, including x86\_64. For this tutorial we only need the i386 toolchain.

Step 3.1 - Extract flashregion\_1\_bios.bin flashregion\_0\_flashdescriptor.bin

````shell
[coreboot]$ cd util/ifdtool
[ifdtool]$ make

[ifdtool]$ sudo cp ifdtool /usr/bin/
````

Download https://libmicro.dev/hax.bin or use bins/hax.bin

`````shell
[extracted_libmicro]$ ifdtool -x hax.bin
Warning: No platform specified. Output may be incomplete
File hax.bin is 16777216 bytes
Peculiar firmware descriptor, assuming Ibex Peak compatibility.
  Flash Region 0 (Flash Descriptor): 00000000 - 00000fff
  Flash Region 1 (BIOS): 00001000 - 00efefff
  Flash Region 2 (Intel ME): 00fff000 - 00000fff (unused)
  Flash Region 3 (GbE): 00fff000 - 00000fff (unused)
  Flash Region 4 (Platform Data): 00fff000 - 00000fff (unused)


[extracted_libmicro]$ ll -h
total 15M
drwxr-xr-x 1 u u 4.0K May 29 16:17 ./
drwxr-xr-x 1 u u 4.0K May 29 16:14 ../
-rw-r--r-- 1 u u 4.0K May 29 16:17 flashregion_0_flashdescriptor.bin
-rw-r--r-- 1 u u  15M May 29 16:17 flashregion_1_bios.bin

`````

Step 4 - Clean up and Configuring

`````shell
[coreboot]$ make distclean

[coreboot]$ touch .config
[coreboot]$ ./util/scripts/config --enable VENDOR_UP
[coreboot]$ ./util/scripts/config --enable BOARD_UP_SQUARED
[coreboot]$ ./util/scripts/config --enable NEED_IFWI
[coreboot]$ ./util/scripts/config --enable HAVE_IFD_BIN
[coreboot]$ ./util/scripts/config --set-str IFWI_FILE_NAME "<flashregion_1_bios.bin>"
[coreboot]$ ./util/scripts/config --set-str IFD_BIN_PATH "<flashregion_0_flashdescriptor.bin>"
[coreboot]$ make olddefconfig
`````
or use config.vgacbfshighres\_3840x2160.bak, it has some vga settings

`````shell
[coreboot]$ make distclean

[coreboot]$ mv config.vgacbfshighres_3840x2160.bak .config
[coreboot]$ make olddefconfig
`````

Step 5 - Build coreboot


`````shell
[coreboot]$ make
`````


Step 6 - Fix VGA


https://whensungoesdown.github.io/coreboot_upsquaredpro


ref
-----------

https://anclark.github.io/2022/10/19/coreboot/x200-coreboot/

https://doc.coreboot.org/tutorial/part1.html

https://ceres-c.it/coreboot/mainboard/up/squared/index.html

https://libmicro.dev/about.html

https://doc.coreboot.org/mainboard/up/squared/index.html
