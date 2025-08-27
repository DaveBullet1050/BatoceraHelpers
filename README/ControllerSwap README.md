# Swapping controllers on selected games

In my situation I have 2 permanent USB zero delay arcade controllers - for player 1 and 2.  On occasion, I want to be able to plug in additional gamepad type controllers (e.g. USB 8bitdo - dual shock like controllers) and have these used as player 1 and 2.  Unfortunately Batocera doesn't have a per game "priority" or ability to assign which controllers should be used.  

I want to be able to control which games have controller swapping - so need a per game configuration file.  If the game is present in the file, then the following controllers are swapped:  
Player 1 <-> 3  (if player 3 controller present)  
Player 2 <-> 4  (if player 4 controller present)  

The script needs to skip swapping if the extra controllers are NOT plugged in. i.e. if there are only 2 controllers detected, then don't swap players 1 and 2 for 3 and 4 if there is no player 3 and 4 controllers physically plugged into the system.  

There are only 2 things required:
1. A configuration file - to tell the launcher which roms should have controllers swapped - in "system/rom" format - e.g. mame/1944.zip.  Hand edit this file to include the systems/roms you want included:  
[/userdata/system/configs/controller/controller_swap.cfg](/userdata/system/configs/controller/controller_swap.cfg)  
2. A hacked emulatorlauncher.py:  
[/usr/lib/python3.11/site-packages/configgen/emulatorlauncher.py](/usr/lib/python3.11/site-packages/configgen/emulatorlauncher.py) - this checks whether the launched "system/rom" exists in the configuration file, and if player 3 controller is present, it becomes player 1.  Likewise if player 4 controller is present it becomes player 2 (and player 1 becomes 3 and player 2 becomes 4 - hence swapped)

Remember to run:  
`batocera-save-overlay`  
from the command line to save the updated .py file above, or it will be lost on reboot.  

To ensure the correct order of controllers, you can fix these by setting from ES via START -> CONTROLLER AND BLUETOOTH SETTINGS then set the default controller for each player under "PLAYER ASSIGNMENTS".

## Improvements  
- I should probably fold in the .cfg file into batocera.conf for easier management.  I didn't want to blow that out though at the cost of file read performance.  
- Also should support swapping at a system level (rather than listing each rom in a system)
- A better improvement would be a per system or game assignement order - than a crude swap, with a default order.. that way it would be possible to configure any combination, with some sort of fall backs (being the default for the system or game)
