# Sanwa Restrictor gate selector (TOS GRS) - Automatic 4/8 way restrictor gate

These instructions setup a TOS GRS restrictor gate (for Sanwa joysticks) so that it can select between 4 and 8 way joystick modes when a game launches.  Although this is for Batocera, it should work on any other platform, as long as you have python installed.  If Windows, you'll need to adapt the /usr/bin/tos_grs/get_tos_tty.sh script - as this "finds" the TTY port on Linux that the TOS GRS controller is registered to (for sending commands via python).  On Windows this will be a COMx port.

## TL;DR - I just want to set it up!

1.  Copy these files to these locations (creating directories as required). All default root owner / permissions are fine:
```
/userdata/system/services/sanwa_restrictor
/userdata/system/configs/sanwa_restrictor/roms4way.txt
```  
2. Run:  
```
chmod 755 /userdata/system/services/sanwa_restrictor
```  
3. Enable the service:  
In the main Batocera menu (Emulation station) press: `F4`  to restart ES (so the new service is found).  
Then enable the service by presssing `START` then selecting `SYSTEM SETTINGS -> SERVICES` then toggling the new `SANWA_RESTRICTOR` to enable.  

That should be all you need. No additional software (no exes/binaries as previously mentioned). Just shell scripting and a python helper to reliably write to/read from the TOS GRS controller TTY port.  

The last (and optional) parameter you can set manually in your /userdata/system/batocera.conf is:  
`sanwa_restrictor.dont_store_change=1`  

The above setting will prevent a 4/8 way orientation change during the game from being stored on exit.  This may be useful for kiosk mode or kids playing etc... so they don't muck up your preferred list of games to play 4 way.  
Without this setting, if the 4/8 way orientation is changed (using the supplied button from the TOS GRS kit to toggle 4 or 8 way orientation), then the new orientation will be stored in the roms4way.txt file and restored next time the game is launched. This is handy so you can "learn" new games or preferences.  

## Overview
The 4/8 way restrictor gate allows selection of 4 way (diamond) or 8 way (square) orientation of the restrictor gate on Sanwa joysticks.  The replacement gate (with servo motor attached and with custom control board) is available here from https://thunderstickstudio.com.

First link is a full kit to do one joystick: https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-all-in-one-kit
Then purchase one of these kits for each additional joystick: https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-extension-kit

FYI.... the height of the restrictor gate and servo is about 81mm (from centre top plate where joystick shaft is attached to the tip of the motor servo) if you are needing to plan for controller panel space.

The software that comes with the kit is designed to run on a 32-bit AARM architecture (ie. Pi 3, but not Pi 5 which is 64-bit only) or Windows.  The scripts below should work on any Linux Batocera distribution (x64/86 etc...) as they only require bourne shell and python 3 (both already included in Batocera), so no additional packages / compile etc... are required.

The [sanwa_restrictor](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/services/sanwa_restrictor) services script is a little odd.  Rather than launching a service / daemon, the script creates the script that handles gameStart and gameStop events on Batocera. And in turn, the shell script it creates embeds the python code needed to send the commands to the controller.  This means we can have a single file doing everything and we can enable/disable it (much easier to deploy as self contained) and by using a service, we can leverage ES built in services menu to enable/disable (thus avoiding needing to edit batocera.conf).  When the service is disabled, it deletes the script that handles gameStart/gameStop events to toggle the restrictor.

## Learning new orientations

The sanwa_restrictor service creates the /userdata/system/scripts/sanwa_change.sh script, which does 2 things:
1. When a game is launched by Batocera, it checks whether the game - "emulator/rom" is in the [roms4way.txt](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/sanwa_restrictor/roms4way.txt) file, and if so - tells all  TOS GRS joysticks to switch to 4 way orientation (and if not found, 8 way orientation)  
2. When a game stops, the script queries the current TOS GRS joystick orientation and if different (and assuming there is no sanwa_restrictor.dont_store_change=1 setting in batocera.conf) , updates the roms4wayWithPath.txt, either adding an entry if the orientation is 4 way, or removing if 8 way. Basically a way you can "teach" the config without resorting to manually adding games as 4 way games to the config file (do it by playing and setting - what works best).  The current set pretty much covers the MAME repo, but you can use this to learn other ROMS from other emulators, or MAME games not in the list etc.  

Batocera runs all scripts in the /userdata/system/scripts folder on both game startup and shutdown, passing the name of the ROM and whether a game start or stop event has occurred.  The roms4WayWithPath.txt is exactly the same list of pre-configured 4 way MAME ROM list from the Thunderstick site, but qualified with a `mame/` ROM directory. This allows the same ROM across 2 emulator cores to have a different orientation.  

## Files and commands (should you want to roll your own scripts etc...)

One way to dynamically find the tty device the TOS GRS controller:  
`grep -l -m1 PRODUCT=2341/8036/100 /sys/class/tty/tty*/device/uevent | cut -f 5 -d"/"`  

This will return your device name, eg:  
`ttyACM0`  

This is what the embedded function does in the service when it creates the sanwa_change.sh script.  

Although you can read/write to the TOS GRS tty device directly with echo / read commands, I found this inconsistent as there would be read failures on the result of setting or getting current controller orientation.  I therefore ditched the shell approach and used python pySerial library which is reliable. I still set a timeout on read/write to prevent any hangs (which would cause Batocera to appear frozen as it would wait for all scripts to execute).

The python code is also embeded in the service code and written to the sanwa_change.sh created when the service is enabled.   

## Alternative solutions
This repo https://github.com/ACustomArcade/tos428/releases contains various binaries.

e.g. For a Pi3b+, download the 64bit exe:
https://github.com/ACustomArcade/tos428/releases/download/v1.0/tos428-linux-aarch64
then:
`chmod 755 tos428-linux-aarch64`  

If you run it, without any parameters, you should get something like:  
`2025/01/10 08:42:03 Found tos428: /dev/ttyACM0`  

Then you can pass any of the following parameters:
```
Usage of ./tos428-linux-aarch64:
  -d string
        path to tos428 device. Set to auto to scan for device. On Windows use COM# (default "auto")
  -exportromlist string
        exports the built-in 4-way rom list to specified path
  -info
        display device info
  -r string
        restrictor to apply setting to (default "all")
  -raw string
        raw command to send to the device. Used to support features not currently implemented.
  -rom string
        auto-detect the way for the specified rom
  -romlist string
        file containing list of 4-way roms. Defaults to built-in list.
  -way int
        way to set the restrictor (4 or 8)
```  
i.e. to change the controller to be 4 way:  
`./tos428-linux-aarch64 -way 4`  

the above needs no other libraries / install (i.e. there is no GO runtime required, as it is all compiled in).
