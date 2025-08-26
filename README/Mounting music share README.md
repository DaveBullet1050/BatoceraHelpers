# Mounting an audio share for Kodi / music playing

Say you have your music collection on another machine?  If that machine uses CIFS (Windows file sharing protocol) then you can add a mount to your:  
`/etc/fstab`  

e.g:  
`//192.168.1.8/music /mnt/music cifs _netdev,nofail,username=<user>,password=<pwd> 0 0`  

Explanation:  
`cifs` tells Linux it is a windows file share  
`_netdev`  tells Linux to mount after the network is up  
`nofail`  tells Linux to carry on mounting and booting if the share fails (e.g. the music PC could be off)  

Obviously you can replace the IP address with a hostname, same with the share name.  Don't forget to provide a valid username and password (unless guest access is permitted).  

As you are editing files outside of /userdata, don't forget to run:  
`batocera-save-overlay`  
or your `/etc/fstab` edits will be lost on reboot.   
