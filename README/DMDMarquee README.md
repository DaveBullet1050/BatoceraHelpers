# Getting a DIY DMD marquee working on Batocera V41+ 
<img width="1024" height="402" alt="image" src="https://github.com/user-attachments/assets/d8cb6486-317d-4ce3-8ba7-23fa2ddffb24" />

I wanted to build a do it yourself marquee as per [these instructions](https://wiki.batocera.org/hardware:diy_zedmd).

These are the very parts I ordered.  Incase the links die, I've included images so you can search for other suitable parts:  
[ESP32 + breakout board](https://www.aliexpress.com/item/1005005626482837.html?spm=a2g0o.order_list.order_list_main.96.3f6318021ItRT4)  
Make sure you get the ESP32 + breakout board (to easily connect the pins to the panels). I think the S3 is supported, but I bought the plain ESP32. Check the [Github ZeDMD page](https://github.com/PPUC/ZeDMD)  
<img width="420" height="434" alt="image" src="https://github.com/user-attachments/assets/a45d4d3e-6bb4-49b5-8b0b-5bb700c5525f" />  

[AC/DC voltage adjustable adapter](https://www.aliexpress.com/item/1005007154093960.html?spm=a2g0o.order_list.order_list_main.106.3f6318021ItRT4)  
The display runs best ~4.2v.  This has an analogue voltage adjustment and does sag a little when warm, but that's ok.  Anything ~4v is fine.  It does not affect brightness at all (I use 10 out of 15 as the batocera setting and it is plenty bright)  
<img width="352" height="305" alt="image" src="https://github.com/user-attachments/assets/1c61efb9-62c3-41e0-8663-7aaf10de0955" />  

[P5 LED panels for a 128x32 display](https://www.aliexpress.com/item/1005007440817037.html?spm=a2g0o.order_detail.order_detail_item.3.113df19c8kxllu)  
You can go for smaller or larger (Px).  These measure 300mm wide (each) so 600mm wide total when joined together.  Just order 1 of these as it comes with the 2 panels. Just ensure for the standard definition panels (62x32) you have the "D" pin on the HUB-75 connector as per:  
<img width="213" height="243" alt="image" src="https://github.com/user-attachments/assets/eb3d3eeb-d4c4-4afc-acae-d8249ba9c4ae" />  
<img width="430" height="343" alt="image" src="https://github.com/user-attachments/assets/f9aa7f69-b1d2-456f-855a-4ec4f1d84e4e" />  

[This guide](https://www.pincabpassion.net/t14796-zedmd-installation-english) is extremely useful.  

# Speeding up marquee changes
If you find Batocera DMD marquee changes sluggish or want a choice about whether to change the game marquee on selection in ES or only on launch, then this is for you.

The scripts below and dmd-play update improve performance greatly on slower machines (e.g. Raspberry Pi 3b).  It's less of an issue on a much faster machine and may not be required.  I've modified dmd-play to be able to run interactively (per marquee) just like Batocera does by default, but also be able to run as a service when launched with the "-lp" option.  This means we don't incur slow startup times and simply send the required marquee command to the already running dmd-play.  On a P33b+, marquee update times go from 1.1 seconds (mainly to launch dmd-play on every change) down to 0.02 seconds (since dmd-play is running as a service).  

## Dependencies
You need to be running [ZeDMD firmware 5.1.1 or greater](https://github.com/PPUC/ZeDMD/releases).  I'm running 5.1.4.  You also need the latest dmd-server binary.  Either grab this via Batocera v42 or recompile yourself from the [lbdmdutil repo](https://github.com/vpinball/libdmdutil).  I've uploaded a working dmd-server version for Aarm64 (Pi 3b+) here:
```
/usr/bin/dmdserver
```

## How to setup / install

1. Copy the following files from (in this Repo) /usr/bin:
```
dmd-set-vars.sh
dmd-play-launcher.sh
dmd-restore-last-event.sh
dmd-play
dmd-event-proceed.sh
dmd-get-last-event.sh
dmd-store-last-event.sh
dmd-play-if-changed.sh
dmd-toggle.sh
```

2. Copy these files to your /userdata/system/configs/emulationstation/scripts:
```
system-selected/dmd-simulator.sh
screensaver-start/dmd-simulator.sh
game-selected/dmd-simulator.sh
screensaver-stop/screensaver-stop.sh
```  

3. Copt this is to change to the game marquee when the game is launched from ES (instead of selection - configurable - see below):  
`/userdata/system/scripts/dmd_game_marquee.sh`

4. If you want the fastest performance - copy down this file (you may need to create the services directory) to be able to configure dmd-play to run as a service:
```
/userdata/system/services/dmd_play
```

5. Ensure you make all scripts executable:
```
chmod 755 /usr/bin/dmd*
chmod 755 -R /userdata/system/configs/emulationstation/scripts/*
chmod 755 /userdata/system/scripts/dmd_game_marquee.sh
```

6. Finally persist the file changes you've made under /usr (so not lost on reboot) by running:  
`batocera-save-overlay`  

Now reboot.

## Starting dmd-play as a service
First ensure dmd_real (dmd_server is configured to launch) via the main ES menu (via START button) -> SYSTEM SETTINGS -> SERVICES -> and toggle **DMD_REAL** to start.  
Then you can enable dmd-play as a service by toggling **DMD_PLAY** to start (this will persist on reboot).

## Custom GIF or PNG Marquee files
You can supply your GIF and PNG files and put these in:
```
/userdata/system/dmd/games/<systemname>/<image_matching_rom_name.gif or png>
```
e.g.
```
/userdata/system/dmd/games/mame/commando.gif
```

The scripts match on ROM name - so a ROM called commando.zip will look for commando.gif then fallback to commando.png.  If neither of these are found, the scripts will look for *-marquee files scraped by ES and failing that will display the image / tile of the game.

## Configuration options
These lines are optional.  The scripts will run without them fine.  Add these lines to your /userdata/system/batocera.conf:
```
## DMD Marquee
dmd.zedmd.brightness=10
dmd.format=sd
dmd.zedmd.matrix=rgb
## Listener port if dmd-play is runinng as a service (fastest marquee changing)
dmd.play.port=6788
## For GIF marquees, makes the GIF endlessly play  (Comment out if you want to play a GIF marquee only once)
dmd.play.repeat=yes
## Makes the game marquee change when the game is selected in ES.  If commented out, the system marquee will be displayed when scrolling through games in ES and game marquee will only be displayed on game launch
dmd.change.select=yes
## If dmd.change.select=yes, the delay before displaying marquee.  This is incase the user is quickly selecting games to avoid constant Marquee changes and reduce latency
dmd.change.waittime=0.33
## If you'd prefer to display the current time (12 hour format with colour cycling). If not set, then comment this out to display either your custom screensaver gif is displayed, but if none, then the default batocera marquee image is displayed
dmd.screensaver.clock=yes
```  

## Upgrades...
I ended up recompiling dmdserver and associated libraries from source from the latest versions.  The versions shipped with Batocera V41+ should be fine though.  Note: the latest dmdserver wouldn't connect to the latest Marquee ESP32 firmware v5.1.2 (v5.1.1 was fine).  v5.1.4 is what I am running with, but it displays a ZeDMD banner often, whereas the v3.6.0 shipped with V41+ was clear / dark. I might revert to the shipped version, as I am using a USB connection between Pi and ESP32 and don't need WiFi support of the latest (v5+) firmwares).  Edit: I recompiled the 5.1.4 firmware to remove the DisplayLogo at boot.  There is no out of the box option / feature to suppress the logo when the ESP32 firmware is starting up, so a recompile is required as per the ZeDMD Github page (using platformio).  
