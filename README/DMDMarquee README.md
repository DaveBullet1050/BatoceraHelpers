# Getting a DIY DMD marquee working on Batocera V41+ 
I wanted to build a do it yourself marquee as per [these instructions](https://wiki.batocera.org/hardware:diy_zedmd).

If you find Batocera DMD marquee changes sluggish or want a choice about whether to change the game marquee on selection in ES or only on launch, then this is for you.

The scripts below and dmd-play update improve performance greatly on slower machines (e.g. Raspberry Pi 3b).  I've modified dmd-play to be able to run interactively (per marquee) just like Batocera does by default, but also be able to run as a service when launched with the "-lp" option.  This means we don't incur slow startup times and simply send the required marquee command to the already running dmd-play.  Response times go from 1.1 seconds to launch down to 0.02 seconds to just play (a PNG file) for example.

## Dependencies
You need to be running [ZeDMD firmware 5.1.1 or greater](https://github.com/PPUC/ZeDMD/releases).  I'm running 5.1.4.  You also need the latest dmd-server binary.  Either grab this via Batocera v42 or recompile yourself from the [lbdmdutil repo](https://github.com/vpinball/libdmdutil).  I've uploaded a working dmd-server for Aarm64 (Pi 3b+) here:
```
/usr/bin/dmd-server
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
dmd-play-service-working
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

3. If you want the fastest performance - copy down this file (to be able to configure dmd-play to run as a service):
```
/usr/share/batocera/services/dmd_play
```

4. Ensure you make all scripts executable:
```
chmod 755 /usr/bin/dmd*
chmod 755 -R /userdata/system/configs/emulationstation/scripts/*
```

5. Finally persist the changes for reboot by running:
```
batocera-save-overlay
```

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
I ended up recompiling dmdserver and associated libraries from source from the latest versions.  The versions shipped with Batocera V41+ should be fine though.  Note: the latest dmdserver wouldn't connect to the latest Marquee ESP32 firmware v5.1.2 (v5.1.1 was fine).  v5.1.4 is what I am running with, but it displays a ZeDMD banner often, whereas the v3.6.0 shipped with V41+ was clear / dark. I might revert to the shipped version, as I am using a USB connection between Pi and ESP32 and don't need WiFi support of the latest (v5+) firmwares) 
