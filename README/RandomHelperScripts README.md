# An assortment of helper scripts

These don't warrant their own page:
- Displays a count of how many games on your system: [count-games](/usr/bin/count-games)
- Mounts the overlay file (on /tmp/overlay) so you can massage it: [mount-overlay](/usr/bin/mount-overlay)
- Return the TTY of a specific Dragonwise USB zero delay encoder (controller board): [get-dragonrise-device](/usr/bin/get-dragonrise-device)
- Run a command (optionally with specific arguments) only if the specified time is reached.  Has limitations: [delay-command](/usr/bin/delay-command)

## Generating key presses
Although the [press_f1.py](/usr/bin/press_key_f1.py) is designed to send a key, it is hardcoded to only send F1 and requires a physical keyboard plugged in.

The [press_key.py](/userdata/system/bin/press_key.py) script allows a single or 2 keys to be pressed.  If 2 keys are passed, the first is held whilst the second is pressed, eg running:  
`python press_key.py enter`  
will press and release the ENTER key.  
`python press_key.py alt f4`  
will hold down ALT then press F4 then release both.  

### Installing additional libraries
The only downside, is the press_key.py requires 2 additional python modules not installed by default with Batocera, being:
```
Xlib
pynput
```  

As there is no "pip" to install additional python packages, the easiest option is to just manually install them in a custom location on your SHARE drive (i.e. /userdata) so you don't cause Batocera upgrade problems in future.

1. Download these 2 packages:
https://files.pythonhosted.org/packages/74/d4/6033a97f96fc7d7bb822dab52e2e3c9532256d7ce033fa9675734941b9ac/xlib-0.21.tar.gz  
https://files.pythonhosted.org/packages/f0/c3/dccf44c68225046df5324db0cc7d563a560635355b3e5f1d249468268a6f/pynput-1.8.1.tar.gz  

If the versions have changed / links broken, go here then click on "Download files" and download each .tar.gz file:  
https://pypi.org/project/xlib/#files  
https://pypi.org/project/pynput/#files  

2. Create the following directory:  
`/userdata/system/python-packges`  

3. Unzip both packages downloaded in step #1 and untar them, then within each untarred file, copy the following:  
```
xlib-0.21/Xlib -> /userdata/system/python-packges/Xlib
pynput-1.8.1/lib/pynput -> /userdata/system/python-packges/pynnput
```  
i.e. these are installers, so you are extracting the actual modules out (do not create xlib-0.21 etc... in the target location.  

If you want another location for these packages, you can, just remember to change the path to them at the top of the press_key.py script.  
