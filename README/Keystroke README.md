# Keystroke generation and mapping

## Simulated key presses

What say you want to generate/inject an actual keypress?  This python script (used to tell the C64 to continue with the game after swapping C64 game disks) can be adapted to send any number of key presses.  [press_key_f1.py](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/bin/press_key_f1.py).  

It dynamically tries to guess hthe device for the keyboard attached to your system (assuming you have one).  The for loop is purely there to grab the first evdev (/dev/input/eventX) device which has a "Keyboard" description.  No point sending the key to some random device on the evdev list!  

The above is only for generating keys "From nothing".  If you want to map an actual controller movement to a keyboard key press, then pad2key is for you...  

## pad2key (send controller joystick movement/buttons as key events)
Some games are just keyboard oriented and do not accept joystick input.  Although this page is dedicated to VIC 20 and C64 keyboard oriented games, the same concepts should work for any other keyboard centric emulator or game.  

Batocera provides pad2key, which essentially listens for controller events (joystick and button presses) then when they are detected (combinations are allowed) one (or more) keystrokes can be sent to the game / emulator.  
You can set these at an emulator level, see [c64.keys](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/evmapy/c64.keys) as an example.  For example in c64.keys:
```
...
        {
            "trigger": "x",
            "type": "key",
            "target": "KEY_F11"
        },
...
```
The above says when "x" button (aka [P1 green button](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/README/Controller%20Reference%20README.md#physical-layout)) is pressed, then send the F11 key to the game.  VICE defaults F11 to "warp mode" so I saw no reason to change.  Although VICE will auto-warp drive and tape access, I found any "compute" functions were also slow... so you can hold the P1 green button aka X (or F11 if you have a keyboard plugged in) to "warp" VICE any time.  I didn't combine say the SELECT (hotkey) with the X button, since the green button has no input into the Vic20/C64 (i.e. unused).  

You can also create a "pad2key" profile via the main Batocera (ES) menu at either system or game level.  Hold down the button to launch the game, and a popup "per game" menu will show, allowing you to create/edit a pad to key profile. In there, you can map which of your joystick axes or buttons generate what keys.

For a complete list of target key enums, see: [Batocera evmapy keys](https://wiki.batocera.org/evmapy#keys)  

The other keys in the c64.keys file are:  
- pageup (aka P1 pink button) sends the Escape key which defaults in VICE = Run/stop key  
- pagedown (aka P1 white button) sends the Scroll lock key which defaults in VICE = Game focus toggle. (When Game Focus = ON - the emulator will receive all raw key inputs, without any interception / defeat by the emulation layers above).  You need for example Game Focus = On to play Ultima games in C64 or for example some keys just wont work (such as A=attack... rather useful!)  

You can also override them per game, by adding a "<full rom name>.keys" file in the same rom directory as the game, eg:  
```
Jupiter Lander - VIC Super Lander (1981)(Commodore)(NTSC)[CG][A000].crt
Jupiter Lander - VIC Super Lander (1981)(Commodore)(NTSC)[CG][A000].crt.keys
```
You can see more examples here:  
[c20 keys](https://github.com/DaveBullet1050/BatoceraHelpers/tree/main/userdata/roms/c20)  
[c64 keys](https://github.com/DaveBullet1050/BatoceraHelpers/tree/main/userdata/roms/c64)  

The c64 examples above allow a joystick to control movement (and player attack via a button), by sending the joystick and firebutton as the default movement keys in Ultima (being @ : ; and /).  

One more thing, and this may be related to Game Focus mode.  If you are playing c64 games via vice under RetroArch (as a libretro core) which is the default in Batocera, you need to unmap the buttons you are planning to override with a pad2key profile.  If you don't, Retroarch will "Consume" the button presses and never give these to evmapy (for pad2key generation).  To "unmap" buttons in Retroarch, that you want to map via a pad2key profile, you assign them to "nul" in batocera.conf, eg:  
```
c64["Gateway to Apshai.d64"].retroarch.input_player1_y_btn=nul
c64["Gateway to Apshai.d64"].retroarch.input_player1_x_btn=nul
c64["Gateway to Apshai.d64"].retroarch.input_player1_l_btn=nul
```
The above means that retroarch will not consume Y, X or L button mappings, since I have a pad2key profile for that game, that maps those buttons to generate keypresses F3, F5 and F7.  

Whilst pad2key supports controller event -> key generation, I couldn't find a way to get it to do key event -> key generation (i.e. press one key and have it generate another).  I believe evmapy (on which pad2key is based?) handles this but never got to the bottom of it.  That led me to the following solution for how to map one key press to another for VICE games...

## VICE key mapping
As the C64 had no arrow/cursor keys for movement, games had to resort to other key combinations.  For Ultima, @ : ; and / Commodore keys are used for up/left/right/down movement and a pain.  Wouldn't it be nice to use your normal keyboard arrow keys?  You can do that via editing the [sdl_pos.vkm](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/bios/vice/c64/sdl_pos.vkm.ultima) file.  A youtuber explained the code / format, but I've already modified the following rows in the file, to map the up/left/right/down arrow keys to the commodore @ : ; / equivalents:  
```
273 5 6 0              /*           Up -> @		       */
276 5 5 0              /*         Left -> :			   */
275 6 2 0              /*        Right -> ;            */
274 6 7 0              /*         Down -> /		       */
```  
The first code is the keycode (273) is generated when you press your arrow up cursor key (don't change that).  The next 2 come from the table in the file (see below) and last code is an OR'ed value for CBM/shift key combinations.  

To explain - let's take the Up key mapping to "@".  Up is keycode 273 (this was already in the default file) as per:  
`273 0 7 1              /*           Up -> CRSR UP      */`  
Because "Up" direction in Ultima is "@" key, this is found in the mapping table using row/column position (the next 2 numbers). as per:  
```
# C64 keyboard matrix:
#
#       +-----+-----+-----+-----+-----+-----+-----+-----+
#       |Bit 0|Bit 1|Bit 2|Bit 3|Bit 4|Bit 5|Bit 6|Bit 7|
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
# |Bit 0| DEL |Retrn|C_L/R|  F7 |  F1 |  F3 |  F5 |C_U/D|
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
# |Bit 1| 3 # |  W  |  A  | 4 $ |  Z  |  S  |  E  | S_L |
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
# |Bit 2| 5 % |  R  |  D  | 6 & |  C  |  F  |  T  |  X  |
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
# |Bit 3| 7 ' |  Y  |  G  | 8 ( |  B  |  H  |  U  |  V  |
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
# |Bit 4| 9 ) |  I  |  J  |  0  |  M  |  K  |  O  |  N  |
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
# |Bit 5|  +  |  P  |  L  |  -  | . > | : [ |  @  | , < |
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
# |Bit 6|POUND|  *  | ; ] | HOME| S_R |  =  | A_UP| / ? |
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
# |Bit 7| 1 ! |A_LFT| CTRL| 2 " |SPACE|  C= |  Q  | R/S |
# +-----+-----+-----+-----+-----+-----+-----+-----+-----+
```
i.e. 5 6  

Finally, the last number (shiftflag) is zero is we don't need a shift / combination key to be sent at the same time as per:  
`# 0x0000      0  key is not shifted for this keysym/scancode`  

Therefore we get:  
`273 5 6 0              /*           Up -> @		       */`  

Which says, when we press up arrow keyboard key (273) send an @ key to the emulator - comprised of bits 5 6 (from the matrix above).  

To get the joystick working - we then have a ".keys" file for each Ultima game which sends selected same joystick movements and buttons to the original movement and attack keys for Ultima, ie: [Ultima 1.d64.keys](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/roms/c64/Ultima%201.d64.keys).  The target key is your actual keyboard, not the Commodore key, This generates the physical (i.e. US101 keyboard) key events, eg:
```
        {
            "trigger": "left",
            "type": "key",
            "target": "KEY_SEMICOLON"
        },
```
Left joystick direction will send the physical US101 keyboard semicolon key, which is then mapped by VICE via the .vkm file to the Commodore colon key (left movement in game) as per:  
`59 5 5 8               /*            ; -> :            */`  

Remember - pad2key files generate the physical keyboard event from your joystick axis or button movement, then the emulator (VICE) has its own key mapping to map the keys to the keyboard of the emulated machine.  

The reason the /userdata/bios/vice/c64 directory has 3 files (and I linked to the Ultima one) is I only want to map the arrow keys to the above keyboard keys for Ultima. There's a script which runs on game start and stop, [c64_ultima_keyboard.sh](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/scripts/c64_ultima_keyboard.sh) which toggles which keyboard is in play.  The one with a ".default" extension is used for all non-Ultima C64 games and switched in, vs. ".ultima" when any Ultima game is playing.  

## VICE disk swap

### Configuring a multi-disk game
Some C64 games are multi-disk requiring you to eject, switch then close the virtual 1541 drive during a game.  This is achieved via configuring a ".m3u" file for such games and placing them in the same directory as the ROM (.d64) files.  See [Ultima 4.m3u](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/roms/c64/Ultima%204.m3u) as an example:  
```
ULTIMA4A.D64|Side A - Program Disk
ULTIMA4B.D64|Side B - Towns
ULTIMA4C.D64|Side C - Britannia
ULTIMA4D.D64|Side D - Underworld
```  
The format is:  
`<filename>|<Friendly name>`  

The filename is the full name including file extension and friendly name is whatever you want VICE to display when you change disks.  

### Manual swapping
Once we setup the above file and update our game collection / scraper.  The problem is we now have 5 "Ultima 4" games being displayed in Emulation Station (one for the .m3u and 4 for the game disks).  We can hide the game disks by holding the launch (P1 red button on my machine) on each of the .d64 entries in ES, to bring up the game specific configuration menu.  Then select Edit This Game's Metadata -> Hidden and toggle on, then save.  This will hide that .d64 from display.  Do this for each .d64 until just the .m3u is showing.  

Although the above groups the disks together for a game, we need a way of toggling / activating the disk swap.  These mappings in [batocera.conf](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/batocera.conf) achieve this:  
```
### You need to toggle game focus off for these keys to work (by pressing scroll_lock key), so Game Focus = OFF), then eject the disk (via pageup key), select disk (via either insert or home to scroll up / down through the disks) then close the virtual drive door (via pageup again)
c64.retroarch.input_disk_prev="insert"
c64.retroarch.input_disk_next="home"
c64.retroarch.input_disk_eject_toggle=pageup
### controller button equivalents for the above - again need to have game focus = off (scroll_lock key toggles)
c64.retroarch.input_disk_prev_btn=0
c64.retroarch.input_disk_next_btn=3
c64.retroarch.input_disk_eject_toggle_btn=4
```  
The comments should be self explanatory on how the keys / buttons work.  For the button code mapping, see: [Physical to virtual mapping](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/README/Controller%20Reference%20README.md#physical-to-virtual-mapping)  

When ejecting a disk, swapping and closing the virtual drive door, you'll see popup messages from Retroarch.  

### Semi-automated swapping

Rather than having to manually eject, then press previous / next, working out which direction and which disk to load.... can we do that via API?  Yes we can!  
We can send commands to RetroArch over its UDP/55355 port.  The full set of the command enumerations are documented here: https://github.com/libretro/RetroArch/blob/94dce4001ee5c8329216bca8fd0043061129986c/command.h#L438  

To send a command we can use netcat (aliased as nc):  
`echo -n "DISK_EJECT_TOGGLE" | nc -c -u -w1 127.0.0.1 55355`  

Tells retroarch to perform a disk eject command.  

We can then string together the commands to eject, go previous/next then eject(load) the disk.  We need to inject a sleep() between them to allow the emulator time to complete the actions, then finally we can inject a keypress (e.g. for Ultima IV) to tell the game to continue. Basically, we want one "key" (or could be mapped to a controller hotkey button combo etc...) to press to change to the right disk and continue the game.

I created the [load_disk.sh](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/bin/load_disk.sh) script which takes as a single parameter, the number / index of the disk to load.  e.g. say you have a 4 disk game like Ultima IV, then:
`load_disk.sh 3`  
Will jump to the 3rd disk (assuming there is a 3rd disk) by using netcat to eject, scroll through (previous/next disk) then eject again to reload the disk, finally pressing the F1 Key if we are playing Ultima IV.  The index number is determined by the order of disks in your .m3u file.  

The problem with netcat, is it only returns success or failure.  As only eject disk, previous disk and next disk are supported, there is no way to query the current index nor set the name of the disk to jump to.  The above script first ejects the current disk, then skips forward or back until the desired disk number is reached, finally closing the drive.    No problem, the load_disk.sh script writes a /tmp/curr_disk.txt file to track the last loaded disk (and this file is removed when the game is stopped to reset).  

The final piece of the puzzle is how to simulate an F1 key press to allow Ultima IV to continue?  

Batocera uses triggerhappy to listen to and generate key presses (this is outside of any emulator).  However Batocera triggerhappy config is system wide and not intended to be per game.  I don't want the disk change keys to be usable outside of Ultima IV (otherwise some games may need the numeric keypad and I'll be generating spurious actions).  So instead I switch in/out the triggerhappy config file to map numeric keys 1-4 as the Ultima disk change keys in a game start/stop script that also switches out the keyboard maps: [c64_ultima_keyboard.sh](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/scripts/c64_ultima_keyboard.sh).  
The default triggerhappy config is: [multimedia_keys.conf.default](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/multimedia_keys.conf.default).  The Ultima specific one is: [multimedia_keys.conf.ultima](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/multimedia_keys.conf.ultima)  

We can see for the Ultima one, when the numeric keypad key 2 is pressed, load_disk.sh 2 is called to switch Ultima to the 2nd disk.  

At the end of the load_disk.sh script, I check if the game is Ultima (after previously storing which game was started here: [tos_grs_switch.sh](https://github.com/DaveBullet1050/BatoceraHelpers/blob/9dfe15f27f923c2b4396246be1f2f1f23ce95272/userdata/system/scripts/tos_grs_switch.sh#L92)) then I send the F1 key using this Python script: [press_key_f1.py](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/bin/press_key_f1.py).  This completes the disk change over AND tells Ultima Iv to continue from a single key press. Nice!  

### Execution of commands from another device
If you don't want to use a keyboard or controller, you can use any other SSH device e.g. a phone, laptop etc... to invoke the script load_disk.sh script.  SSH Button for Android works well for this.  Using Ultima IV as an example (which has 4 disks), I have configured 4 commands, one for each disk:  
![SSH buttons](../image/load_disk%20ssh%20config.png)  

Here's what the 3rd disk command looks like:  
![SSH config](../image/SSH%20config%20disk%203.png)  
