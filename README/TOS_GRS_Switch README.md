# TOS GRS - Automatic 4/8 way restrictor gate

The 4/8 way restrictor gate allows selection of 4 way (diamond) or 8 way (square) orientation of the restrictor gate on Sanwa joysticks.  The replacement gate (with servo motor attached and with custom control board) is available here from https://thunderstickstudio.com.

First link is a full kit to do one joystick: https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-all-in-one-kit
Then purchase one of these kits for each additional joystick: https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-extension-kit

The software that comes with the kit is designed to run on a 32-bit AARM architecture (ie. Pi 3, but not Pi 5 which is 64-bit only) or Windows.  The scripts below should work on any Linux Batocera distribution (x64/86 etc...) as they only require bourne shell capability.

## Files and commands (should you want to roll your own scripts etc...)

One way to dynamically find the tty device the controller:  
`grep -l -m1 PRODUCT=2341/8036/100 /sys/class/tty/tty*/device/uevent | cut -f 5 -d"/"`  

This will return your device name, eg:  
`ttyACM0`  

I've put the above in the script [get_tos_tty.sh](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/bin/tos_grs/get_tos_tty.sh) which will return a fully qualified /dev/ttyXXX so you can then send commands.  

The commands are simply done via echo to the tty then a read to see the result.  A value of zero "0" or "all" can be used to send the same command to all attached joysticks, otherwise numbers 1-4 can be used to switch individual jouysticks.

This sets the direction of the all joysticks 4 to way (assuming your device is what is reported above):  
```
echo setway,all,4 > `/usr/bin/tos_grs/get_tos_tty.sh`
```
or if you want to hardcode the port - remember port may vary system by system:  
```
echo setway,all,4 > /dev/ttyACM0
```

To confirm the result of the command, we can read from the same tty into a variable:  
```
read rc < `/usr/bin/tos_grs/get_tos_tty.sh` 
echo $rc
```  

Which will either be ok or err.  

If we want to read the orientation of joystick 1 we can send:
```
echo getway,1 > `/usr/bin/tos_grs/get_tos_tty.sh`
```
Then read the result stored on the tty via the read command above.  We will get either 4 or 8 as a result.  

## Automatic switching of TOS GRS restrictor gate between 4 and 8 way

Assuming you have installed the [get_tos_tty.sh](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/bin/tos_grs/get_tos_tty.sh) script, you can use this script to automatically load 4 or 8 way mode per ROM / game.  
`/userdata/system/scripts/tos_grs_switch.sh`  

The above script will also store the selected setting when you exit a game, so it can be "remembered" on next play.  This assumes you've wired your TOS GRS button up and can switch modes during play.  Close the emulator and the current setting for that ROM will be stored.  Don't forget to chmod 755 so it is executable.

Also download the file that contains the ROMS that should be 4 way (otherwise 8 way is the default):  
`/userdata/system/configs/tos_grs/roms4wayWithPath.txt`  

When you are playing a game, if you want to change the orientation, use the supplied button to toggle, then on game exit, the tos_grs_switch.sh script will run and update/store the preference for that game so it will be recalled next play.

The only configuration parameter for tos_grs_switch.sh is:  
`roms4wayFile=/userdata/system/configs/tos_grs/roms4wayWithPath.txt`  

Change the above if you place file containing roms that should be in 4-way position in a different location.

Batocera runs all scripts in the /userdata/system/scripts folder on both game startup and shutdown, passing the name of the ROM and whether a game start or stop event has occurred.  The roms4WayWithPath.txt is exactly the same list of pre-configured 4 way MAME ROM list from the Thunderstick site, but qualified with a `mame/` ROM directory. This allows the same ROM across 2 emulator cores to have a different orientation. 
