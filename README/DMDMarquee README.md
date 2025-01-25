# Getting a DMD marquee working on Batocera V39
I didn't want to upgrade Batocera.  I had a stable build, working with all the emulators I needed.  I previously found v40 broke Daphne (laserdisc games) so didn't want to risk v41+ bugs.  However, I wanted to build a do it yourself marquee as per [these instructions](https://wiki.batocera.org/hardware:diy_zedmd).

The problem with the DIY marquee is software support was only introduced in Batocera v40.

This page is dedicated to getting the DIY marquee running on v39 (and may possibly work on earlier versions).

## Files required
I've uploaded the v40 files in this repo for a Pi3, using the paths linked below.  Alternatively,if you have different hardware you could download the v40 image, instal and extract them yourself.
```
/usr/lib/libzedmd.so.0.7.4
/usr/lib/libdmdutil.so.0.7.0
/usr/lib/libpupdmd.so.0.4.1
/usr/bin/dmd-play
/usr/bin/dmdserver
/usr/bin/dmdserver-config
/usr/share/batocera/services/dmd_real
/usr/bin/dmd-simulator
/usr/share/batocera/services/dmd_simulator
/usr/share/dmd-simulator/*
```

Also run:
```
cd /usr/lib
chmod 755 libzedmd.so.0.7.4
chmod 755 libpupdmd.so.0.4.1
chmod 755 libdmdutil.so.0.7.0
ln -s libzedmd.so.0.7.4 libzedmd.so
ln -s libpupdmd.so.0.4.1 libpupdmd.so
ln -s libdmdutil.so.0.7.0 libdmdutil.so
chmod 755 /usr/bin/dmd*
chmod 755 /usr/share/batocera/services/dmd*
chmod 755 /usr/share/dmd-simulator/scripts/*
```  

## Python numpy module
The dmd_real service requires python's numpy module.  But since Batocera doesn't ship with the python package installer "pip", we have to do that first, before installing numpy.  Run the following:  
```
python -m ensurepip
python -m pip install numpy
```  

## Starting the service
In ES, select SYSTEM SETTINGS -> SERVICES.  You should see DMD_REAL listed.  Toggle to start.  You can check for errors in /userdata/system/logs/es_script_stderr.log
