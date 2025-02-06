# Getting a DIY DMD marquee working on Batocera V41+ 
I wanted to build a do it yourself marquee as per [these instructions](https://wiki.batocera.org/hardware:diy_zedmd).

There were a few changes I wanted to make:
1. The batocera (ES) events fire on every system or game selection and play the GIF or PNG if found.  This bogged down ES menu / game navigation when flicking through games quickly
2. The [dmd-play](https://github.com/batocera-linux/dmd-simulator/blob/master/dmd-play.py) utility that ships with Batocera V41 doesn't allow graceful termination (closure) of the connection to the dmdserver if an interrupt is sent (you'll see why this is important below)
3. I also wanted to add colour cycling to the clock and display that when the ES screensaver kicks in

What I did is created a bunch of custom scripts - working off ES events:
system-selected
game-selected
screensaver-start
screensaver-stop (the latter not scripted by Batocera but supported by ES)

The first 2 scripts record the system or game selected and wait (~ 1 second). If the user has moved to another selection, the script dies and doesn't set the marquee (GIF or PNG).  This keeps the UI responsive.  Should the user settle on a game (and GIF/PNG playing) and quickly move, then the scripts acquire a mutex (simple /tmp directory creation) to ensure only one attempts to call dmd-play at a time.  Although dmdserver can handle multiple clients, I don't want to bog the system down with lots of unneeded connections.  When the first script finishes, the 2nd script acquires the mutex and plays its marquee.  If however by the time the mutex is acquired, the 2nd script has been superceeded (by more mouse moves) it terminates. Basically the scripts attempt to keep up with the latest user selection.  By supporting interrupt termination in dmd-play I am able to send a -SIGINT and have it gracefully close the connection to dmdserver.

When it comes to the screen saver, if you have the DIM setting (ES -> USER INTERFACE -> SCREENSAVER), then a 12 hour system clock will be displayed when ES goes into screensaver mode and will colour cycle.  It will cancel automatically on any controller input and restore the last displayed marquee.

## Files required
I've uploaded the v40 files in this repo for a Pi3, using the paths linked below.  Alternatively,if you have different hardware you could download the v40 image, instal and extract them yourself.
```
/usr/bin/dmd-play
/usr/bin/dmd-helper/*
/userdata/system/configs/emulationstation/scripts/*
```  

You also need to supply your GIF and PNG files and put these in:
```
/userdata/system/dmd/games/<systemname>/<image_matching_rom_name.gif or png>
```  

## Starting the service
In ES, select SYSTEM SETTINGS -> SERVICES.  You should see DMD_REAL listed.  Toggle to start.  You can check for errors in /userdata/system/logs/es_script_stderr.log

## Upgrades...
I ended up recompiling dmdserver and associated libraries from source from the latest versions.  The versions shipped with Batocera V41+ should be fine though.  Note: the latest dmdserver wouldn't connect to the latest Marquee ESP32 firmware v5.1.2 (v5.1.1 was fine).  v5.1.1 is what I am running with, but it displays a ZeDMD banner often, whereas the v3.6.0 shipped with V41+ was clear / dark. I might revert to the shipped version, as I am using a USB connection between Pi and ESP32 and don't need WiFi support of the latest (v5+) firmwares) 
