# Visual Pinball (VPinball) on Batocera (v41)  

## Mapping controller buttons  
I ended up bypassing all the controller mapping in the vpinballx.ini.  I couldn't find reliable documentation to map button and axis numeric values.  It all seemed a bit hit and miss. Not all buttons were recognised.
So I created my own custom evmapy.json that I just get evmapy.py to copy in when it exists for the system in the evmapy folder.  I also set grab: true to ensure pad2key / evmapy handles all controller events and none are passed through to VPinball to interpret and cause confusion / spurious movements.

Here is my custom evmapy [vpinball.json](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/evmapy/vpinball.json), which is copied over if present by system via this custom [evmapy.py](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/lib/python3.11/site-packages/configgen/utils/evmapy.py)  

I'm using a [USB zero delay encoder](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/README/Controller%20Reference%20README.md), but once you have your [es_input.cfg](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/configs/emulationstation/es_input.cfg) for your controller, you should be able to re-map the required button references and codes in the vinpball.json to work for you.  Note: Unlike the source .keys files that batocera uses for pad2key and generates an evmapy compatible json, evmapy does not support a description for each axis/button, hence why the buttons I've mapped are not described in the json (adding a description causes an evmapy error).  

## Getting a table to work

### 1. Get the VPX file
First you need the ".vpx" file (see key sites below for sources).  Put it in:  
`/userdata/roms/vpinball`  

If you have a 2nd screen - then you will also need the .b2s file (with same filename as the rom).  You don't need the .b2s file if you are playing on a single screen.  You also don't need the .b2s file if you have a DMD marquee (the vpx alone is enough to drive this).  I have one of [these](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/README/DMDMarquee%20README.md)  

### 2. Check you have the required ROMs
These will either be listed for the VPX where you download it.  If not - launch the game and open the:  
`/userdata/system/configs/vpinball/vpinball.log`  

And check for the rom name specified in the newVal= entry - see below:  
```
2025-04-04 08:33:45.230 INFO  [27425] [VPinMAMEController::VPinMAMEController@229] PinMAME window disabled
2025-04-04 08:33:45.230 INFO  [27425] [VPinMAMEController::put_GameName@697] newVal=medusa
2025-04-04 08:33:45.230 INFO  [27425] [VPinMAMEController::put_GameName@702] Game found: name=medusa, description=Medusa, manufacturer=Bally, year=1981
```  
Search for the rom on one of the key sites below or google it., eg: "vpinball rom medusa"

I prefer to put all my roms in /userdata/system/configs/vpinball/pinmame/roms. To configure this, press START in ES and select -> GAME SETTINGS -> PER SYSTEM ADVANCED CONFIGURATION -> Visual Pinball X and Toggle the PER TABLE FOLDER so it is "off / disabled"

The ROMS are in zip format, leave them as a ZIP and copy them into:  
`/userdata/system/configs/vpinball/pinmame/roms`  

Some ROMS may need depend on other ROMS (e.g. afm_113b may need afm_113 as well).  So download similar named ROMS if your table still doesn't play.  

### 3. ROM has an alias... and VPMAlias.txt isn't supported on Linux  
Some tables require you to alias the rom.  As this isn't supported, you need to amend the table to use the original rom.  We do this by extracting the VBS script from the (compiled) VPX and editing the rom name to match 

For example, the Fleetwood Mac table (Fleetwood.vpx) will look for a Fleetwood.zip ROM.  Now the actual rom is dollyptb.zip, and the VPMAlias.txt would normally point Fleetwood -> dollyptb.  

To change the table to look for dollyptb do the following:  
1. Extract the VBS from the VPX via:  
`/usr/bin/vpinball/VPinballX_GL -ExtractVBS /userdata/roms/vpinball/Fleetwood.vpx`  

2. Edit the extracted VBS script and change the rom name of the following:  
`Const cGameName = "Fleetwood"		 'The unique alphanumeric name for this table`  
to  
`Const cGameName = "dollyptb"		 'The unique alphanumeric name for this table`  

Then the table should launch correctly.  

### 4. Check if your table has a patch VBS script
Some tables just briefly open then close / crash.  A fix script may be what you need. Check: https://github.com/jsm174/vpx-standalone-scripts/tree/master and download the .VBS file contained in the folder for your game (ignore the .patch / other scripts).  The .VBS must have exactly the same filename as your .VPX.  

### 5. Music and other things
I found the file locations were a bit hit and miss and didn't quite follow the [Batocera vpinball v41 wiki guide](https://wiki.batocera.org/systems:vpinball).  I found creating a /userdata/roms/vpinball/\<name of table here\>/music as per the wiki didn't work.  This is a bit trial and error.  If the music comes in its own folder, eg: Halloween/ - then simply place this directly under /userdata/roms/vpinball  

### 6. Final things
If the VPX still doesn't play check the /userdata/system/configs/vpinball/vpinball.log for errors.  The machine may just not work under the VPX Standalone emulator that Batocera uses, e.g. Steve Miller Band is noted as a "No" for Standlone emulator support.  I could get the table to launch but not play, even with all the roms present.

If your table launches and you can briefly see it then it closes / crashes - you'll likely need a .VBS patch script (as per above).  
If the table launches and your coin button works, but start button does nothing (no ball appears) - then you are missing one or more ROM zip files.  

## Flippers stuck in the up position
I found this on Apollo 13.  This was caused because the vpmInit procedure wasn't being called.  Ensure a call to:
`vpmInit Me`  
is in the _Init procedure at the top of your .VBS file (assuming you downloaded one as described above to get the VPX to work).  Could be called GoldenEye_Init etc...... For apollo 13 the procedure was called Table1_Init:
```
Sub Table1_Init
	On Error Resume Next
	vpmInit Me
	With Controller
		.GameName=cGameName
		.SplashInfoLine = "Sega Apollo 13"&chr(13)&"by UnclePaulie"
		If Err Then MsgBox "Can't start Game" & cGameName & vbNewLine & Err.Description : Exit Sub
		.HandleMechanics=0
		.HandleKeyboard=0
		.ShowDMDOnly=1
		.ShowFrame=0
		.ShowTitle=0
		.Hidden=varhidden
		.Games(cGameName).Settings.Value("rol")	= 0
		.Games(cGameName).Settings.Value("sound") = 1 ' Set sound (0=OFF, 1=ON)	
		.Run GetPlayerHWnd
		If Err Then MsgBox Err.Description
```  
## Key sites
https://vpuniverse.com - tables and roms  
https://www.vpforums.org - tables and roms

## Other help
This dude on Reddit has written a useful guide that may answer some questions: https://www.reddit.com/r/batocera/comments/1abqxow/the_lazy_batocera_v38_builders_guide_to_visual/  
