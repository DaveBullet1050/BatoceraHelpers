# Custom screen resolution

I use an old school 4:3 HP 2035 LCD monitor.  This has a native 1600x1200 resolution @ 60Hz refresh rate.  

I changed the monitor resolution / refresh rate in batocera.conf as per:
`es.resolution=1600x1200.60000`  

And for various emulators:  
```
c20.videomode=1600x1200.60000
...
mame.videomode=1600x1200.60000
...
megadrive.videomode=1600x1200.60000
...
daphne.videomode=640x480.60000
```  

With Daphne, I found overriding the native resolution to the video native of 640x480 best (assuming your monitor can handle VGA res).  

And whilst this was fine for ES, I recall having problems when games launched.  I therefore hacked the [batocera-resolution](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/bin/batocera-resolution) script to force 1600x1200 via this section:
```
    else
        MAXWIDTH=1600
        MAXHEIGHT=1200
    fi
```
The above hack may not be needed.

# Screen rotation

If you are running under a Retroarch core, then you can get retroarch to do it. I only know of emulator or per game settings. I don't think this can be done on a collection level:  

eg.. for 3ds/nds core games....  
```
3ds.retroarch.video_rotation=270
nds.retroarch.video_rotation=270
```  
The above will get batocera to add these at launch for any 3ds or Nds game to the retroarchcustom.cfg and let retro natively orientate the display without scripting  
