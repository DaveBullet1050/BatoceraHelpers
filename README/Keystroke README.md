# Keystroke generation and mapping

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
