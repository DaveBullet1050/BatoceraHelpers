# Daphne (laserdisc games)

Daphne seems to be broken in v40, so if your games are crashing, then revert to v39.  v41 may have fixed the hypseus/singe (aka Daphne) emulator, but I haven't tested it.

Hypseus uses its own contoller configuration files, but Batocera invoked Hypseus with a "--gamepad" option and I couldn't get Hypseus to recognise my controller buttons nor joystick.  The solution was to hack the Batocera [Daphne Generator](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/lib/python3.11/site-packages/configgen/generators/daphne/daphneGenerator.py) script to omit the --gamepad option.  Then I could get Hypseus to recognise my controller and use my own controller [custom.ini](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/daphne/custom.ini).  

If you need to find the correct codes to use in custom.ini for a different button layout to mine, then you can use the [hypjsch_cli](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/bin/hypjsch_cli) executable to spit out the correct button codes.  

Run:
`hypjsch_cli`  

And it will wait for joystick/button input.  If I press player 1 red (aka B) button, I get:  

```
[root@BATOCERA /etc]# hypjsch_cli

2 joystick(s) found - (Third column provides template config only)

DragonRise Inc.   Generic   USB  Joystick  :    Button: 004     - KEY_[ACT] = SDLK_[KEY] 0 004
```

As you can see in [custom.ini](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/daphne/custom.ini), this matches the player 1 fire button (button 1) which also maps to Left-CTRL on a keyboard:  
`KEY_BUTTON1 = SDLK_LCTRL 0 004`  

Using the above CLI utility, you can remap / change buttons as needed.
