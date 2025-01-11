# Controller Reference

This page documents how I've configured the 2 Zero delay "DragonRise" decoders on my system.

Looking at the back of the Pi 3b+, I simply plugged them into the top left (player 1) and top right (player 2) USB ports.  I've never had a problem with them "switching" and mucking up the order of player 1 or 2 on reboot.  (i.e. they seem to be sticky).  

I am using [Sanwa JLF-TP-8YT joysticks](https://focusattack.com/sanwa-jlf-tp-8yt-joystick-precursor-to-jlx-tp-8yt/) with the [TOS GRS 4/8 way servo switched restrictor gates](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/README/TOS_GRS_Switch%20README.md#tos-grs---automatic-48-way-restrictor-gate).  I am also using 30mm screw in Sanwa buttons for the player buttons, with a mix of 24mm buttons for coin, select and start and Happ style P1/2 start buttons.  I am also using a cheapo CH-616 coin acceptor, allowing coins to add credits for MAME games.

## Physical layout
My mockup panel is shown below:
![Test panel](../image/Arcade%20panel%20mockup.png)  
Backside:  
![Test panel back](../image/Arcade%20panel%20mockup%20-%20back.png)  

Black labels are what you see in Emulation Station and RetroArch - essentially mapping to a virtual gamepad style controller (aka XBox/PS etc...)
Red labels are where the button physically plugs into the USB zero delay encoder (starting at a zero offset, i.e. button 1 plugs into slot 0) as per:  
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


