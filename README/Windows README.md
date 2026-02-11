# Windows games

## Phantom, "stuck" or continuous joystick direction inputs (without actually moving the joystick)
If you are using a USB zero delay encoder, you may experience repeated joystick presses once you launch a game.  i.e. when you trigger down or right, the emulator keeps receiving inputs in that direction (symptom is in game menus just scroll indefinitely or characters are just going in one direction in game).  

The problem is caused by the encoder starting in analog mode (red LED).  It needs to be in dpad/digital mode (green LED).  

### Hardware solution
To switchover, there are 2 options:
1. Wire a button to MODE and press when powering on or connecting the controller
2. If you are lucky and have one of these boards, move the resistor pointed to, so it connects across the "J1" labelled points - ie. move the resistor "up one".  This starts the controller in digital mode, and you can still use the MODE button if desired to toggle to analog mode.  
<img width="1020" height="507" alt="image" src="https://github.com/user-attachments/assets/9d134997-c6b7-4da4-9982-da11a02991b0" />

### Software solution
If you cannot apply the hardware solution (preferred), then this software "hack" can be used.  I found the problem is in the generated SDL_GAMECONTROLLERCONFIG environment variable, inspected by WINE to check what controller movements are supported.  When "dpad" directions (dpup, dpdown, dpleft, dpright) are added for zero delay encoder type controllers AND the controllers are in analog mode (RED LED), this causes the repeat problem.  I also found Batocera was not generating the required "leftx:a0,lefty:a1" which meant the joysticks weren't working at all in other windows games.

My solution was to edit the:
```
/usr/lib/python3.11/site-packages/configgen/generators/wine/wineGenerator.py
/usr/lib/python3.11/site-packages/configgen/controller.py
```

scripts so that I could configure which systems / games to skip dpad settings or add leftx/lefty.

If your controller is named:
`DragonRise Inc.   Generic   USB  Joystick  `  

then the prefix in the batocera.conf would be:  
`dragonrise`  
i.e. first word  

You can find your controller name by launching (then exiting) any of your windows games then opening:
`/userdata/system/logs/es_launch_stdout.log`  

and finding the line with:  
`SDL_GAMECONTROLLERCONFIG=03000000790000000600000010010000,DragonRise Inc.   Generic   USB  Joystick  ,platform:Linux,b:b4,a:b3,lefttrigger:b6,leftstick:b10,rightshoulder:b5,leftshoulder:b2,righttrigger:b7,y:b1,x:b0,start:b9,back:b8,leftx:a0,lefty:a1,`  

You can add the following lines to:  
`/userdata/system/batocera.conf`  

`<system>["<game>"].<your_controller_name>_skip_dpad=true`  
Will cause the dpad entries to be skipped when generating the config (fixing phantom joystick movements)
and  
`<system>["<game>"].<your_controller_name>_add_leftx=true`  
Will cause the leftx entries to be added (enabling joystick movement)  

Here's my settings, preventing dpad entry on just broforce but ensuring leftx/lefty is added for all Windows games:  
```
windows["Broforce.wine"].dragonrise_skip_dpad=true
windows.dragonrise_add_leftx=true
```  
