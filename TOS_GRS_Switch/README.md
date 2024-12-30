# TOS GRS - Automatic 4/8 way restrictor gate

The 4/8 way restrictor gate allows selection of 4 way (diamond) or 8 way (square) orientation of the restrictor gate on Sanwa joysticks.  The replacement gate (with servo motor attached and with custom control board) is available here from https://thunderstickstudio.com.

First link is a full kit to do one joystick: https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-all-in-one-kit
Then purchase one of these kits for each additional joystick: https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-extension-kit

The software (on the same page) is designed to run on a Raspberry Pi - but on 32-bit / Armv7 Linux (Retropie).  Batocera v39+ is Aarch64 therefore does not have native 32-bit library support.  The good news is Batocera linux is compiled with 32-bit compatibility, so you can provide your own 32-bit library dependencies, and run the library with a 32-bit executable target (as shown below):

## First, confirm your Batocera linux has been compiled with 32-bit compatibility
run:
```
zcat /proc/config.gz | grep CONFIG_COMPAT=
```
you should get:
```
CONFIG_COMPAT=y
```
if you have 32-bit compatibility enabled. This is required in order to launch the pre-compiled 32-bit tos428cl.exe

## Second, you'll need the following 2 32 bit libraries to make tos428cl.exe run

```
/usr/bin/tos_grs/ld-linux-armhf.so.3
/usr/bin/tos_grs/libc.so.6
```

You can either get these from the folder in this repo or download these (extract from within /usr/lib) for an Rpi3 from:
http://fl.us.mirror.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz

Note: if you are running a Pi4/5 - you may need libraries specific to those versions.

## How to run tos428cl.exe

Now, you don't want to overwrite your 64 bit system libraries, so the easiest option is to copy the two 32 bit libraries you extracted to the same directory as the tos428cl.exe executable.  Ensure you chmod 755 the libraries and executable

Assuming your file locations are as follows:
```
/usr/bin/tos_grs/tos428cl.exe
/usr/bin/tos_grs/ld-linux-armhf.so.3
/usr/bin/tos_grs/libc.so.6
```
You can launch the executable as follows:  
`cd /usr/bin/tos_grs`  

Gets the current <port> (/dev/ttyxxx) for the connected controller (used to change orientation).  Use in subsequent commands:  
`./ld-linux-armhf.so.3 --library-path ${PWD} ./tos428cl.exe getport`  

Switches all joysticks connected to 4 way mode:  
`./ld-linux-armhf.so.3 --library-path ${PWD} ./tos428cl.exe <port> setway,all,4`  

Switches all joysticks connected to 8 way mode:  
`./ld-linux-armhf.so.3 --library-path ${PWD} ./tos428cl.exe <port> setway,all,8`  

Lastly, don't forget to save the overlay as you've modified files under /usr (or Batocera will lose these on reboot):  
`batocera-save-overlay`  

If you get any:  
`-bash: ./tos428cl.exe: cannot execute: required file not found`  
or other errors - check you have the correct libraries and they are in the same path as the exe and you are launching using the library method above (and all files have executable permissions, e.g. chmod 755 ...)

## Automatic switching of TOS GRS restrictor gate between 4 and 8 way

Assuming you have your TOS GRS tos428cl.exe running as per above, you can use this script to automatically load 4 or 8 way mode per ROM / game.  
`/userdata/system/scripts/tos_grs_switch.sh`  

The above script will also store the selected setting when you exit a game, so it can be "remembered" on next play.  This assumes you've wired your TOS GRS button up and can switch modes during play.  Close the emulator and the current setting for that ROM will be stored.  Don't forget to chmod 755 so it is executable.

Also download the file that contains the ROMS that should be 4 way (otherwise 8 way is the default):  
`/userdata/system/configs/tos_grs/roms4wayWithPath.txt`  

When you are playing a game, if you want to change the orientation, use the supplied button to toggle, then on game exit, the tos_grs_switch.sh script will run and update/store the preference for that game so it will be recalled next play.

The only 2 configuration parameters for tos_grs_switch.sh are:  
`tos428exe=/usr/bin/tos_grs/tos428cl.exe`  
`roms4wayFile=/userdata/system/configs/tos_grs/roms4wayWithPath.txt`  

Change the above if you place the files pointed to in different locations.

Batocera runs all scripts in this folder on both game startup and shutdown, passing the name of the ROM and whether a game start or stop event has occurred.  The roms4WayWithPath.txt is exactly the same list of pre-configured 4 way MAME ROM list from the Thunderstick site, but qualified with a `mame/` ROM directory. This allows the same ROM across 2 emulator cores to have a different orientation. 
