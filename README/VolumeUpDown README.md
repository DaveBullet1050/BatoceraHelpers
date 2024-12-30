# Controller based volume up / down

To enable volume control, you can use any combination of controller buttons via the triggerhappy daemon running on Batocera. Using a button combination means in normal play, these buttons won't normally be pressed together, so it makes sense to choose something like your hotkey (SELECT) button in combination with a volume up and down button.  

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
The order of buttons is signficant. If the combination doesn't work, swap the order.  In my example, the hotkey has to be placed at the end of the combination.  '1' tells triggerhappy that an "on" for the button combo should call the command, which is batocera-audio with a setSystemVolume parameter.  The +5 or -5 is a percentage.
