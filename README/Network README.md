# Network including static IP

All of these are due to stability problems I was having - either my router mis-behaving with DHCP allocations or Pi built in WiFi defaults.  Also some other random config (e.g. SAMBA) which may be useful.

## Disabling power management on default Wifi (wlan0)

I added:  
`iwconfig wlan0 power off`  

to init.d startup script [S07network](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/etc/init.d/S07network).  

This seems to help with stability of WiFi connections.  

## Allocating a static IP
There's no way to do this currently in Batocera, so I hacked in a static IP via connman startup [S08connman](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/etc/init.d/S08connman):  
```
		IPv4=192.168.1.13/255.255.255.0/192.168.1.1
		Nameservers=8.8.8.8,8.8.4.4
		IPv6=off
```  

Also need to set the IP in the /etc/hosts file via [S26system](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/etc/init.d/S26system):  
`        echo "192.168.1.13	${hostname}"          >> /etc/hosts`  

## SAMBA root share
I added this to the [smb.conf](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/etc/samba/smb.conf) to be able to share / to NFS clients:  
```
[root]
comment = batocera.linux root
path = /
writeable = yes
guest ok = yes
create mask = 0644
directory mask = 0755
force user = root
```

## Router woes
My router was set to "auto" channel config.  This meant the router would either change channels or choose a conflicting channel.  In both cases, there would be a disconnect without reconnect on Batocera.  Ensure you change the channel on your router to a static setting.  For me in New Zealand, I used channel 3 and haven't had a problem since.  No changes are needed Batocera side.

samba maintains its own user/password list, so you may need to run:  
`smbpasswd -a root`  

And add root/give a samba password. I can't recall.
