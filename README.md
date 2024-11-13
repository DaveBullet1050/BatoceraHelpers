# BatoceraHelpers
A bunch of config or how to scripts / info for a Batocera gaming machine.

## TOS GRS - Automatic 4/8 way restrictor gate

The 4/8 way restrictor gate allows selection of 4 way (diamond) or 8 way (square) orientation of the restrictor gate on Sanwa joysticks.  The replacement gate (with servo motor attached and with custom control board) is available here from https://thunderstickstudio.com.

First link is a full kit to do one joystick: https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-all-in-one-kit
Then purchase one of these kits for each additional joystick: https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-extension-kit

The software (on the same page) is designed to run on a Raspberry Pi - but on 32-bit / Armv7 Linux (Retropie).  Batocera v39+ is Aarch64 therefore does not have native 32-bit library support.  The good news is Batocera linux is compiled with 32-bit compatibility, so you can provide your own 32-bit library dependencies, and run the library with a 32-bit executable target (as shown below):

1. First, confirm your Batocera linux has been compiled with 32-bit compatibility
zcat /proc/config.gz | grep CONFIG_COMPAT=

you should get a:
CONFIG_COMPAT=y

if you have 32-bit.

2. You'll need the following 2 32 bit libraries to make tos428cl.exe run:

ld-linux-armhf.so.3
libc.so.6

You can download these (extract from within /usr/lib) for an Rpi3 from:
http://fl.us.mirror.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz

3. Now, you don't want to overwrite your 64 bit system libraries, so the easiest option is to copy the two 32 bit libraries you extracted to the same directory as the tos428cl.exe executable.  Ensure you chmod 755 the libraries and executable

Assuming your file locations are as follows:
/usr/bin/tos_grs/tos428cl.exe
/usr/bin/tos_grs/ld-linux-armhf.so.3
/usr/bin/tos_grs/libc.so.6

You can launch the executable, as per:

cd /usr/bin/tos_grs
./ld-linux-armhf.so.3 --library-path ${PWD} ./tos428cl.exe

If you get any:
-bash: ./tos428cl.exe: cannot execute: required file not found

or other errors - check you have the correct libraries and they are in the same path as the exe and you are launching using the library method above (and all files have executable permissions, e.g. chmod 755 ...)

## Automatic switching of TOS GRS restrictor gate between 4 and 8 way

