# Batocera Helpers
A bunch of config or how to scripts / info for a [Batocera](https://batocera.org/) gaming machine.  All of this was running successfully on v39 on a Raspberry Pi 3B+.  Therefore some may not work on a later version of Batocera or on another architecture (e.g. x86).  

There are no ROMS included in this repo for obvious legal and copyright reasons.  Also the advice I'm giving is on my own account and has not been endorsed by the devs at Batocera (infact they may likely object to much of it!).  So please use at your own risk.  I've included it here as it may help you with any problems you are having (at least understand where things are done and have examples to look at).  Any changes to any Batocera supplied scripts or code can be thought of as sub-optimal hacks, either working around my lack of detailed configuration knowledge or a specific feature that doesn't exist that I wanted to add.

As with any system, before you apply any of these changes, do a backup!  You can do this via plugging in a USB stick formatted to exFAT, the via the main ES menu: System Settings -> Backup User Data (Target Device = should show your USB stick) -> Start.

If making any changes to files in any other location other than /userdata, remember to run:  
`batocera-save-overlay`  
To persist your changes (otherwise they will be lost on reboot).  

This repo contains my batocera overlay file (expanded into the directories and files you see) plus other config / scripts (under /userdata).  If using any of the config or scripts linked under these pages, simply copy to the same structure in this repo - to your Batocera machine.  i.e. files under /usr/bin/tos_grs get copied to the same location (create directories if required).  The help pages below link to the relevant files for configuring that feature:  

[Controller Reference](./README/Controller%20Reference%20README.md#controller-reference)  
[TOS GRS - Automatic 4/8 way restrictor gate](./README/TOS_GRS_Switch%20README.md#tos-grs---automatic-48-way-restrictor-gate)  
[GPIO based shutdown / startup for Pi 3B+](./README/PowerOffOn%20README.md#gpio-based-shutdown--startup-for-pi-3b)  
[Controller based volume up / down](./README/VolumeUpDown%20README.md#controller-based-volume-up--down)  
[Coin acceptor / slot](./README/CoinAcceptor%20README.md#coin-acceptor--slot)  
[Daphne (laserdisc games)](./README/Daphne%20README.md#daphne-laserdisc-games)  
[Custom screen resolution](./README/ScreenRes%20README.md#custom-screen-resolution)  
[Keystroke generation and mapping](./README/Keystroke%20README.md#keystroke-generation-and-mapping)  
[Side by side cabinet screen flip for MAME games](./README/SideBySide%20README.md)  
[Batocera backup](./README/Backup%20README.md)  
[Network including static IP](./README/Network%20README.md)  
[DIY LED Marquee on Batocera V39](./README/DMDMarquee%20README.md)  
