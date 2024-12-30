# Keystroke generation and mapping

## pad2key (send controller joystick movement/buttons as key events)
Some games are just keyboard oriented and do not accept joystick input.  Although this page is dedicate to VIC 20 and C64 keyboard oriented games, the same concepts should work for any other keyboard centric emulator.

Batocera provides pad2key - which essentially listens for controller events (joystick and button pushes) then when they are detected (combinations are allowed) one (or more) keystrokes can be sent to the game / emulator.

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
The above says when "x" button (aka P1 green button) is pressed, then send the F11 key to the game.  VICE defaults F11 to "warp mode" so I saw no reason to change.  Although VICE will auto-warp drive and tape access, I found any "compute" functions were also slow... so you can hold the green button (or F11 if you have a keyboard plugged in) to "warp" VICE any time.

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

Whilst pad2key supports controller event -> key generation, I couldn't find a way to get it to do key event -> key generation (i.e. press one key and have it generate another).  I believe evmapy (on which pad2key is based?) handles this but never got to the bottom of it.  

## VICE key mapping

For Ultima, using @ : ; and / Commodore keyboard keys are a pain for character movement.  Wouldn't it be nice to use your normal keyboard arrow keys?  You can do that via editing the [sdl_pos.vkm](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/bios/vice/c64/sdl_pos.vkm.ultima) file.  A youtuber explained the code / format, but I've already modified the following rows in the file, to map the up/left/right/down arrow keys to the commodore @ : ; / equivalents:  
```
273 5 6 0              /*           Up -> @		       */
276 5 5 0              /*         Left -> :			   */
275 6 2 0              /*        Right -> ;            */
274 6 7 0              /*         Down -> /		       */
```  
The first code is the keycode (don't change that).  The next 2 come from the table in the file and last code is an OR'ed value for CBM/shift key combinations.  

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

To get the joystick working - we then have a ".keys" file for each Ultima game which sends selected same joystick movements and buttons to the original movement and attack keys for Ultima, ie: [Ultima 1.d64.keys](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/roms/c64/Ultima%201.d64.keys)  

The reason the /userdata/bios/vice/c64 directory has 3 files (and I linked to the Ultima one) is I only want to map the arrow keys to the above keyboard keys for Ultima. There's a script which runs on game start and stop, [c64_ultima_keyboard.sh](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/scripts/c64_ultima_keyboard.sh) which toggles which keyboard is in play.  The one with a ".default" extension is used for all non-Ultima C64 games and switched in, vs. ".ultima" when any Ultima game is playing.  
