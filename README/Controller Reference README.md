# Controller Reference

This page documents how I've configured the 2 Zero delay "DragonRise" decoders on my system.

Looking at the back of the Pi 3b+, I simply plugged them into the top left (player 1) and top right (player 2) USB ports.  I've never had a problem with them "switching" and mucking up the order of player 1 or 2 on reboot.  (i.e. they seem to be sticky).  

I am using [Sanwa JLF-TP-8YT joysticks](https://focusattack.com/sanwa-jlf-tp-8yt-joystick-precursor-to-jlx-tp-8yt/) with the [TOS GRS 4/8 way servo switched restrictor gates](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/README/TOS_GRS_Switch%20README.md#tos-grs---automatic-48-way-restrictor-gate).  I am also using 30mm screw in Sanwa buttons for the player buttons, with a mix of 24mm buttons for coin, select and start and Happ style P1/2 start buttons.  I am also using a cheapo CH-616 coin acceptor, allowing coins to add credits for MAME games.

## Physical layout
My mockup panel is shown below:
![Test panel](../image/Arcade%20panel%20mockup.png)  
Black labels are what you see in Emulation Station and RetroArch - essentially mapping to a virtual gamepad style controller (aka XBox/PS etc...)
Red labels are where the button physically plugs into the USB zero delay encoder (starting at a zero offset, i.e. button 1 plugs into slot 0).  
Backside:  
![Test panel back](../image/Arcade%20panel%20mockup%20-%20back.png)  

Here's the physical USB zero delay encoder (aka Dragonrise as recognised in Linux/Batocera) as per:  
![USB Encoder](../image/USB%20zero%20delay%20encoder.png)  

There is no way to configure each (player 1 and 2) USB delay encoders with a different button configuration.  ES / Batocera only has one configuration for one type of controller, therefore you must lay out Player 2 buttons the same way (albeit there are no physical select and start buttons as per player 1).  The purple glowing button on the top left is the TOS / GRS 4/8 way selector which connects to its own controller board (which itself is USB attached to the Pi).  Refer to the last in: [es_input.cfg](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/emulationstation/es_input.cfg), ie:  

```
	<inputConfig type="joystick" deviceName="DragonRise Inc.   Generic   USB  Joystick  " deviceGUID="03000000790000000600000010010000">
		<input name="a" type="button" id="4" value="1" code="292" />
		<input name="b" type="button" id="3" value="1" code="291" />
		<input name="down" type="axis" id="1" value="1" code="1" />
		<input name="l2" type="button" id="6" value="1" code="294" />
		<input name="l3" type="button" id="10" value="1" code="298" />
		<input name="left" type="axis" id="0" value="-1" code="0" />
		<input name="pagedown" type="button" id="5" value="1" code="293" />
		<input name="pageup" type="button" id="2" value="1" code="290" />
		<input name="r2" type="button" id="7" value="1" code="295" />
		<input name="right" type="axis" id="0" value="1" code="0" />
		<input name="up" type="axis" id="1" value="-1" code="1" />
		<input name="x" type="button" id="1" value="1" code="289" />
		<input name="y" type="button" id="0" value="1" code="288" />
		<input name="start" type="button" id="9" value="1" code="297" />
		<input name="select" type="button" id="8" value="1" code="296" />		
	</inputConfig>
```  

You don't have to wire your USB zero delay controller to buttons in the same order.  It's just the order I plugged them in.  I've shown this purely so it helps visualise the setup in the various config files in this repo (i.e. when reading batocera.conf and button "5" is referenced, you know which one it is).  

## Physical to virtual mapping
My config files all reference the buttons as follows:
![Button mapping](../image/Button%20mapping.png)  

## Full set of configured button combinations
The full open office spreadsheet to show you how the various hotkey combinations and per game overrides I've setup in batocera.conf is here:  
[Button mapping spreadsheet](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/image/Button%20mapping.ods)  

## How controller mapping works
The basic process is
1. Base ES mapping
2. Batocera uses the ID from controller axis/buttons in the batocera.conf (globally, per core or per game)
3. Batocera generates the relevant config files for the emulator.  For example, Retroarch uses 2 config files. One for the emulator core and one for retroarch itself (more on these below)
4. Batocera launches the emulator, it reads the just generated config files and you play your game with your desired controller mapping  

### Emulation Station mapping
Batocera packages Emulation Station with a bunch of controllers pre-configured.  The mappings are in:  
`/userdata/system/configs/emulationstation/es_input.cfg`  

If you want to change the mapping of buttons system wide, then using ES is the best way to do it (via ES main menu -> CONTROLLER & BLUETOOTH SETTINGS -> CONTROLLER MAPPING).  

To get the ID and CODE values to use (see example above), run:  
`sdl2-test -l`  

Which will list all controllers attached and all events supported (joystick axis and buttons) with codes.  And give you a "joystick number:" for each, eg:  
```
# sdl2-jstest -l
Found 2 joystick(s)

Joystick Name:     'DragonRise Inc.   Generic   USB  Joystick  '
Joystick Path:     '/dev/input/event2'
Joystick GUID:     03000000790000000600000010010000
Joystick Number:    0
Number of Axes:     5
Number of Buttons: 12
Number of Hats:     1
Number of Balls:    0
GameControllerConfig:
  Name:    'USB gamepad'
  Mapping: '03000000790000000600000010010000,USB gamepad,a:b2,b:b1,back:b8,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,leftshoulder:b4,leftstick:b10,lefttrigger:b6,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b11,righttrigger:b7,rightx:a3,righty:a4,start:b9,x:b3,y:b0,platform:Linux,'
Axis code  0:    0
Axis code  1:    1
Axis code  2:    2
Axis code  3:    3
Axis code  4:    5
Button code  0:   288
Button code  1:   289
Button code  2:   290
Button code  3:   291
Button code  4:   292
Button code  5:   293
Button code  6:   294
Button code  7:   295
Button code  8:   296
Button code  9:   297
Button code 10:   298
Button code 11:   299
Hat code  0:   -1
```  

You can then run:  
`sdl-jstest -e 0`  

And get a running list of events.  Pressing a joystick axis, or buttons will return something like this.  Here's my "A" button:  
`SDL_JOYBUTTONUP: joystick: 0 button: 4 state: 0 code:292`  

As you can see I map the button (ID) and code (CODE) in the es_input.cfg:  
`		<input name="a" type="button" id="4" value="1" code="292" />`  

Another utility than can display button codes is:  
`evtest`  

### Batocera.conf settings - Retroarch example
If you configure Batocera (via Emulation Station) to use a "libretro" based core to emulate your games, you can change or map any of the Retroarch functions.

At step 3 above in the launch process Batocera generates 2 Retroarch files:  
```
/userdata/system/configs/retroarch/retroarchcustom.cfg
/userdata/system/configs/retroarch/cores/retroarch-core-options.cfg 
```  
I find it easiest to launch a retroarch game, then look at what values are in the above files, then reverse engineer what should go into batocera.conf, eg:  
```
<core_name>.retroarch.<setting>=<value>
<core_name>.retroarchcore.<setting>=<value>
```  

i.e. the settings from:  
`/userdata/system/configs/retroarch/retroarchcustom.cfg`  
go into  
`<core_name>.retroarch.<setting>=<value>`  

and those in:  
`/userdata/system/configs/retroarch/cores/retroarch-core-options.cfg`  
go into  
`<core_name>.retroarchcore.<setting>=<value>`  

If you need keymaps, [input_keymaps.c](https://github.com/libretro/RetroArch/blob/master/input/input_keymaps.c) has the full list.  

Do read [retroarch.cfg](https://github.com/libretro/RetroArch/blob/master/retroarch.cfg) thoroughly as it explains a lot on how retroarchcustom settings works.  

For example - if you want to launch all c64 games for a retroarch core with a 270 degree screen rotation, we find this in retroarchcustom.cfg as:  
`video_rotation = 0`  

Therefore our batocera.conf should contain:  
`c64.retroarch.video_rotation=270`  

If you want to disable inputs for a key or button you can assign "nul" to these, eg:  
```
global.retroarch.input_hold_fast_forward_btn=nul
global.retroarch.input_load_state_btn=nul
global.retroarch.input_save_state_btn=nul
```  
Strip the _btn suffix if you want to disable the keyboard binding for that operation.  

See my [batocera.conf](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/batocera.conf) for various examples.
