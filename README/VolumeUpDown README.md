# Controller based volume up / down

To enable volume control, you can use any combination of controller buttons via the triggerhappy daemon running on Batocera. The reason I wanted to use triggerhappy is it works at the operating system level. That means I can control Linux/ALSA volume independent of any particular emulator behaviour / capability.  You want to use button combinations that won't normally be pressed together, so it makes sense to choose something like your hotkey (SELECT) button in combination with any other convenient player 1 buttons for volume up and down.  

First we need to work out what events are generated for each button, so we can name them correctly in the triggerhappy file.  

Run:  
`evtest`  
and enter the event number corresponding to the controller that will be used for volume control:  
```
[root@BATOCERA /etc]# evtest
No device specified, trying to scan all of /dev/input/event*
Available devices:
/dev/input/event1:      CHICONY HP Basic USB Keyboard
/dev/input/event2:      soc:shutdown_button@3
/dev/input/event3:      DragonRise Inc.   Generic   USB  Joystick
/dev/input/event4:      DragonRise Inc.   Generic   USB  Joystick
/dev/input/event5:      vc4-hdmi
Select the device event number [0-5]: 3
```

In my case, I am using 2 DragonWise USB zero delay encoders. Player one is registered in the system as /dev/input/event3 and player 2 is /dev/input/event4.  

After you enter your device event number, you'll get a running list of any events generated on the device.  Press your hotkey button and release, then CTRL-C to stop evtest so you can see the button enumeration, eg:
```
Event: time 1735519425.383007, type 1 (EV_KEY), code 296 (BTN_BASE3), value 1
Event: time 1735519425.383007, -------------- SYN_REPORT ------------
```
In the above:
`BTN_BASE3`  
is my select/hotkey

I've chosen the pageup and pagedown buttons (as per Batocera/Retroarch mapping) for volume up and down (respectively).  Their codes are:
```
BTN_THUMB2
BTN_PINKIE
```
Combine the codes using a '+' and put these in a custom multimedia.conf ie:
`/userdata/system/configs/multimedia_keys.conf`  

For example:
```
BTN_THUMB2+BTN_BASE3	1	batocera-audio setSystemVolume +5
BTN_PINKIE+BTN_BASE3	1	batocera-audio setSystemVolume -5
```
The order of buttons is signficant. If the combination doesn't work, swap the order.  In my example, the hotkey has to be placed at the end of the combination.  '1' tells triggerhappy that an "on" for the button combo should call the command, which is batocera-audio with a setSystemVolume parameter.  The +5 is go up 5% in volume or -5, down 5%.

I set my amplifier volume knob to half way. This provides enough range for volume adjustment without having to physically access the amp / inside the machine.  To set the initial volume to midway, eg. 55%, set:  
`audio.volume=55`  
in your batocera.conf, then you can increase / decrease via the buttons.  

To reload your new multimedia_keys.conf, run:  
`/etc/init.d/S50triggerhappy restart`  

If you get any errors, this is because by default Batocera launches the triggerhappy daemon to bind the controls to all devices under /dev/input/event*.  This may cause a problem where a controller (e.g. plugged in keyboard) does not support the button you want to use.  In this case, hack the S50triggerhappy script to only listen on controllers you want to bind (e.g. /dev/input/event2 which is always my P1 controls on my zero delay encoder). 
