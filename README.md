# Batocera Helpers
A bunch of config or how to scripts / info for a [Batocera](https://batocera.org/) gaming machine.  All of this is running successfully on vanilla Batocera v41 on an x64 (Intel PC).  I say "vanilla" as there are pre-packaged Batocera images with ROMS etc.. and they may have incompatible scripts / updates to those contained in this repo.   

**The scripts / changes in this repo will only work on Batocera version 41.  Do not apply to other versions! or you WILL break your system!**

This repo is not a fork from Batocera.  The scripts provided are meant to be installed "copy down" into the same location on your Batocera machine as in this repo.  Also the advice I'm giving is on my own account and has not been endorsed by the devs at Batocera.  Most of these changes can be removed by simply deleting the `/boot/boot/overlay` file.  So please use at your own risk.  I've included it here as it may help you with any problems you are having (at least understand where things are done and have examples to look at).  Batocera may provide other ways to implement these, but I couldn't find them, hence my own customisations.  

As with any system, before you apply any of these changes, do a backup!  You can do this via plugging in a USB stick formatted to exFAT, the via the main ES menu: System Settings -> Backup User Data (Target Device = should show your USB stick) -> Start.

If making any changes to files in any other location other than under /boot or /userdata (i.e. anywhere else under root - "/"), remember to run:  
`batocera-save-overlay`  
To persist your changes (otherwise they will be lost on reboot).  

These instructions assume your Batocera machine is booting, Wifi / networking is up and you can connect to the machine via SSH (and you understand what this means) or use the console for running commands.  Whilst you don't need any Linux/Shell command line knowledge, having it helps!  

This repo contains my batocera overlay file (expanded into the directories and files you see) plus other config / scripts (under /userdata).  If using any of the config or scripts linked under these pages, simply copy to the same structure in this repo - to your Batocera machine.  i.e. files under /usr/bin/tos_grs get copied to the same location (create directories if required).  The help pages below link to the relevant files for configuring that feature:  

Start here. I use a USB Zero delay encoder with Sanwa sticks and buttons.  It's important as it is referenced throughout these guides and in the config files I've uploaded:  
[Controller reference](./README/Controller%20Reference%20README.md#controller-reference)  

Cabinet design:  
[Cabinet design](./README/Cabinet%20design%20README.md)  

Now... what would you like to configure?:  
[Batocera backup](./README/Backup%20README.md)  
[Coin acceptor / slot](./README/CoinAcceptor%20README.md#coin-acceptor--slot)  
[Controller based volume up / down](./README/VolumeUpDown%20README.md#controller-based-volume-up--down)  
[Custom screen resolution](./README/ScreenRes%20README.md#custom-screen-resolution)  
[Daphne (laserdisc games)](./README/Daphne%20README.md#daphne-laserdisc-games)  
[DIY LED Marquee on Batocera v41+](./README/DMDMarquee%20README.md)  
[GPIO based shutdown / startup for Pi 3B+](./README/PowerOffOn%20README.md#gpio-based-shutdown--startup-for-pi-3b)  
[Keystroke generation and mapping](./README/Keystroke%20README.md#keystroke-generation-and-mapping)  
[Network including static IP](./README/Network%20README.md)  
[Side by side cabinet screen flip for MAME games](./README/SideBySide%20README.md)  
[TOS GRS - Automatic 4/8 way restrictor gate](./README/TOS_GRS_Switch%20README.md#tos-grs---automatic-48-way-restrictor-gate)  
[Visual Pinball emulator (VPinball) setup v41+](./README/VPinball.md)  
[CamillaDSP - EQ and other audio processing](./README/CamillaDSP.md)  
[Swapping controllers on a per game basis](./README/ControllerSwap%20README.md)  
[Mounting a music share / drive on another PC or SAMBA linux host](./README/Mounting%20music%20share%20README.md)  
[Run script on directory change - auto update custom collections](./README/RunScriptOnDirectoryChange%20README.md)  
[Windows / WINE emulation tips](./README/Windows%20README.md)  
[Streaming from Batocera - using Sunshine and Moonlight](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/README/Streaming%20README.md)  
[Other assorted random helper scripts or utiliites](./README/RandomHelperScripts%20README.md)  

## Coming...  
- Steam tips  
