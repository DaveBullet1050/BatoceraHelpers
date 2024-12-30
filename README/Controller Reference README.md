# Controller Reference

This page documents how I've configured the 2 Zero delay "DragonRise" decoders on my system.

Looking at the back of the Pi 3b+, I simply plugged them into the top left (player 1) and top right (player 2) USB ports.  I've never had a problem with them "switching" on reboot.  (i.e. they seem to be sticky).  

I am using [Sanwa JLF-TP-8YT joysticks](https://focusattack.com/sanwa-jlf-tp-8yt-joystick-precursor-to-jlx-tp-8yt/) with the [TOS GRS 4/8 way servo switched restrictor gates](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/README/TOS_GRS_Switch%20README.md#tos-grs---automatic-48-way-restrictor-gate).  I am also using 30mm screw in Sanwa buttons for the player buttons, with a mix of 24mm buttons for coin, select and start and Happ style P1/2 start buttons.  The coli

My mockup panel is shown below:
![Test panel](../image/Arcade panel mockup.png)  

Black labels are what you see in Emulation Station and RetroArch - essentially mapping to a virtual gamepad style controller (aka XBox/PS etc...)
Red labels are where the button plugs into the USB zero delay encoder (starting at a zero offset, i.e. button 1 plugs into slot 0).  

There is no way to configure each USB delay encoder with a different button configuration.  ES / Batocera only has one configuration for one type of controller, therefore you must lay out Player 2 buttons the same way (albeit there are no physical select and start buttons as per player 1).  The purple glowing button on the top left is the TOS / GRS 4/8 way selector which connects to its own controller board (which itself is USB attached to the Pi).  

You don't have to connect your USB zero delay controller to buttons this way.  It's just the order I plugged them in.  I've shown this purely so it helps visualise the setup in the various config files in this repo.

My config files all reference the buttons as follows:
![Button mapping](../image/Button%20mapping.png)  

The full open office spreadsheet to show you how the various hotkey combinations and per game overrides I've setup in batocera.conf is here:  
[Button mapping spreadsheet](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/image/Button%20mapping.ods)  


