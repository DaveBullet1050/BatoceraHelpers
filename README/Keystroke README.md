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
The above says "when "x" button (aka P1 green button) is pressed, then send the F11 key to the game.  VICE defaults F11 to "warp mode" so I saw no reason to change.  Although VICE will auto-warp drive and tape access, I found any "compute" functions were also slow... so you can hold the green button (or F11 if you have a keyboard plugged in) to "warp" the VICE at any time.

The other keys in the c64.keys file:
pageup (aka P1 pink button) sends the Escape key which defaults in VICE = Run/stop key
pagedown (aka P1 white button) sends the Scroll lock key which defaults in VICE = Game focus toggle. (When Game Focus = ON - the emulator will receive all raw key inputs, without any interception / defeat by the emulation layers above).  You need for example Game Focus = On to play Ultima games in C64 or for example some keys just wont work (such as A=attack... rather useful!)

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

For Ultima, using @ : ; and / Commodore keyboard keys are a pain for character movement.  Wouldn't it be nice to use your normal keyboard arrow keys?  You can do that via editing the [sdl_pos.vkm](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/share/vice/C64/sdl_pos.vkm) file.  A youtuber explained the code / format, but I've already modified the following rows in the file, to map the up/left/right/down arrow keys to the commodore @ : ; / equivalents:
