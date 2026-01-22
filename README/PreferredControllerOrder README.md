# Preferred controller order

Batocera is great at mapping a multitude of controllers.  The problem is the order they are assigned isn't static if you unplug or swap controllers regularly.  This page is about having a "sticky" order for controllers, using the ones available at the time of game launch in a preferred order.  

Whilst you can set controller assignment to  player order system wide, via the CONTROLLER menu, there's 2 problems:  
1. If you disconnect a controller (e.g. a Bluetooth or USB controller), then this mapping is lost
2. Inconsistency in overriding on a per system or game basis.  Some emulators (e.g.Nintendo64) allow you to override which controllers get assigned, but some don't.  Again, if you disconnect a controller - then the order preference is lost  

In my situation I have 2 permanent USB zero delay arcade (Dragonwise) controllers for player 1 and 2.  On occasion, I want to be able to plug in additional handheld controllers, e.g. USB 8bitdo or a wheel and have these used as priority (when present).  Unfortunately Batocera doesn't have a per game "priority" or ability to assign which controllers should be used when an emulator doesn't support it.  I wanted something universal, that didn't care about emulation system being used and allowed for occasionally connected controllers (not losing configuration if unplugged).  

## Required changes
Copy down the following 2 files:  
[/usr/lib/python3.11/site-packages/configgen/emulatorlauncher.py](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/lib/python3.11/site-packages/configgen/emulatorlauncher.py)  
[/usr/lib/python3.11/site-packages/configgen/controller.py](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/lib/python3.11/site-packages/configgen/controller.py)  

Remember to run:  
`batocera-save-overlay`  
to ensure the above are saved for reboot.  

## Configuring preferred controller order
All configuration is held in [/userdata/system/batocera.conf](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/batocera.conf), add as follows:  

### 1. Define the controllers to the system

This is so we can use these when re-ordering.  Since some controller names are long, we create "aliases" so we can use them in the order "rules" (on a per game, system or global basis).  Each alias corresponds to a single model of controller.  For example, say we have 2 USB controllers "Dragonwise" we call "arcade" and an 8bit do controller we call "handheld" and finally a Logitech G923 racing wheel, we'll simply shorten to "wheel".  

First, we need to find the full name of the controllers to assign to your aliases.  Connect the controller(s) to your system and open up the [es_settings.cfg](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/emulationstation/es_settings.cfg) and look for the name of the controller(s) next to the *INPUT_PxNAME* element, eg:   
```
	<string name="INPUT P1NAME" value="DragonRise Inc.   Generic   USB  Joystick  " />
```
Then you can add the following to your batocera.conf (anywhere is fine):    
```
global.controller.aliases=arcade,handheld,wheel

global.controller.alias.handheld=8BitDo Pro 2 Wired Controller
global.controller.alias.arcade=DragonRise Inc.   Generic   USB  Joystick
global.controller.alias.wheel=Logitech G923 Racing Wheel for PlayStation 4 and PC
```
The aliases can be anything you like.  For example, the following will work just fine:    
```
global.controller.aliases=a,b,c

global.controller.alias.b=8BitDo Pro 2 Wired Controller
global.controller.alias.a=DragonRise Inc.   Generic   USB  Joystick
global.controller.alias.c=Logitech G923 Racing Wheel for PlayStation 4 and PC
```
As long as the list of names after "global.controller.aliases", each match a defined alias under "global.controller.alias.<your alias name>"  


Now we can refer to just the aliases in our order rules...  

### 2. Configure the preferred controller order using aliases

As with many batocera.conf settings, we can provide ROM/game specific (e.g. simpsons.zip), system specific (e.g. mame, c64, megadrive) or universal (global) settings.  Batocera will use game over system over global where these match.  Here are 3 examples:  
```
mame["simpsons.zip"].controller.order=arcade,handheld
mame["outrun.zip"].controller.order=wheel,handheld,arcade
megadrive.controller.order=handheld,arcade,wheel
global.controller.order=arcade,handheld,wheel
```  
Note: The controllers don't need to be plugged in permanently, when a game launches, the mapping will use the next best controller in the order list when assigning to the players.  

### 3. Set number of players (controllers) you want to assign

We don't have to assign all available controllers.  For example, we may know the game is limited to 2 players.  We can set the max number of assignments with the following:  
```
mame["simpsons.zip"].controller.players=4
mame["outrun.zip"].controller.players=1
megadrive.controller.players=2
global.controller.players=4
```  
If not defined, 4 players will be assumed.  

### Explanation of examples
For simpsons, the configuration says if there are multiple arcade controllers, assign these first to players 1,2,3,4.  If you run out of arcade controls, start assigning handheld controllers.  e.g. If we had 2 handheld then plugged in an arcade controller, the arcade will be assigned to player 1 (priority) then handheld to players 2 and 3.  Even though simpsons is configured for 4 player controls, a 4th control couldn't be assigned because only 3 were physically plugged into the system.  

For outrun, if we have a wheel, use that for player 1, if no wheel is present, look for a handheld and use that.  Finally find an arcade controller if no wheel nor handheld are present.  Since outrun is set as a 1 player game, only 1 controller will be assigned.  

That's all you need to do.  

If you haven't specified a controller.order for a game (or even for system or globally), then the default Batocera assigned order will be used for all available controllers to the maximum number of players.  

## Limitations

Currently, where multiple controllers exist of the same type/model, these will be assigned in the order detected by the system (and essentially built or assigned by the Kernel/udev under /dev/input) - which is what ES registers I think (and this is passed to the Batocera scripts that build the controller list).  There's no way to identify individual controllers of an identical model as their device IDs are all the same.  I don't think this is much of a problem, as permanently wired (e.g. arcade / zero delay controllers) seem to get consistent order when booting (if you are having problems getting consistent Dragonrise controller order, apply [this](https://wiki.batocera.org/diy-arcade-controls#i_use_dragonrise_encoders_and_player_1_and_player_2_s_inputs_are_swapped).  For occasionally connected controllers, the order plugged in should provide the order assigned.  If not, it's a simple case of handing the controller to the correct player.  
