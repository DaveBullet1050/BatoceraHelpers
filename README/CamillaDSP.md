# CamillaDSP setup

Camilla DSP is digital sound processing software.  It allows you to manipulate the incoming digital sound stream over a number of Linux (and Windows) sound devices.  The possibilities are endless... you can use it as an active crossover for speakers, upmix your 2 channel source to 7 channels, add custom EQ etc...  

In my case, I wanted to use it to tailor the response of the speakers in the cabinet.  My arcade machine uses a tweeter and woofer (per side) with passive crossover, but I wanted to "unify" the bass (below 80Hz), so that both woofers are playing when bass is required.  This will get me some gain.  

The way CamillaDSP works is to listen to a stream and play it out to whatever device you want.  The problem is, most software expects to play to a Pipewire, Pulseaudio, Jack, Alsa etc... device.  For Alsa, we have a solution the "loopback" device.  This takes a playback stream and routes it immediately to a capture stream.  This allows us to "wedge" Camilla DSP in the middle.  This flow below should help explain:  

Normal Alsa playback:  
`Application -> hardware device (e.g. hw:0)`  

CamillaDSP playback (via ALSA Loopback device:  
`Applcation -> Loopback playback device (hw:Loopback,0) -> (hw:Loopback,1) Camilla DSP Capture (CamillaDSP processing) CamillaDSP playback -> hardware device (e.g. hw:0)`  

## Steps to install and configure

### 1. Download CamillaDSP, setup as a service

First download CamillaDSP.  The author has kindly pre-compiled this for Linux using the libraries Batocera already has, so no need to install other packages nor libraries.  Download the latest from the [Releases](https://github.com/HEnquist/camilladsp/releases)  

And place into your:
`/usr/bin`  

To get CamillaDSP to startup on boot, copy down:  
`/userdata/system/services/camilladsp`  

Make executable via:
`chmod 755 /userdata/system/services/camilladsp`  

The service file is hard coded to launch CamillaDSP with my preferred "mono bass below 80Hz" configuration.  You can replace this in the file (argument to camilladsp) with any other CamillaDSP YAML file you like
`/userdata/system/configs/camilladsp/2channel-bass-merge.yaml`  

### 2. Configure the loopback device, alsa and pulseaudio

To add the ALSA loopback device, edit:
`/etc/modules.conf`  
and add
`snd_aloop`  

Now we need to configure an Alsa PCM to handle sample rate conversion and "multiplex" incoming sources to the Loopback device.  This ensures that we can play from multiple sources concurrently, rather than one application or another "hogging" the device.  Copy down the:  
`/etc/asound.conf`  

The above asound.conf file contains a PCM plugin called "dmixerloop".  To get this recognised in Pulseaudio and systems that use it (like Steam games), we need to load the required pulseaudio module.  The easiest option is to edit your:  
`/etc/init.d/S99userservices`  
and add
`pactl load-module module-alsa-sink device=pcm.dmixerloop`  

just before the "test" condition at the bottom.  I tried configuring the /usr/share/pipewire/pipewire-pulse.conf to load this module (when audio is started on boot as part of /etc/init.d/S06audio), but the sink wouldn't load. Maybe because other systems weren't initialised...

After reboot, you can confirm the module has loaded, by running:  
`pactl list sinks short`  

You should get a device called "dmixerloop" in the list, eg:  
```
49      alsa_output.pci-0000_00_1f.3.analog-stereo      PipeWire        s32le 2ch 48000Hz       SUSPENDED
84      alsa_output._sys_devices_platform_snd_aloop.0_sound_card1.analog-stereo PipeWire        s32le 2ch 48000Hz   SUSPENDED
122     alsa_output.pcm.dmixerloop      PipeWire        s16le 2ch 44100Hz       SUSPENDED
```  

### 4. The last thing to do is configure your audio device in Emulation Station (and also Steam if you use it)  

In the main ES menu, press START -> SYSTEM SETTINGS, then change:  
`AUDIO OUTPUT = LOOPBACK ANALOG STEREO`  
`AUDIO PROFILE = LOOPBACK ANALOGUE STEREO OUTPUT`  

If you can't see these, reboot to ensure the loopback device is loaded (snd_aloop that you added above).  

Lastly, if you run Steam games, launch Steam, then press ESC or similar to get the options.  Go down to settings then Audio and select the "alsa pcm.dmixerloop" device.





