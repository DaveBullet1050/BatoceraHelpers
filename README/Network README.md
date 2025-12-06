# Network - stability problems (as well as setting a static IP)

All of these are due to stability problems I was having - either my router mis-behaving with DHCP allocations or Pi built in WiFi defaults.  Also some other random config (e.g. SAMBA) which may be useful.

## Checking if power management is enabled on your wifi device
Run:  
`iwconfig`  

See if power management is set to "off" as per below:  

```
[root@BATOCERA_V41 /userdata/system]# iwconfig
lo        no wireless extensions.

wlan2     IEEE 802.11  ESSID:"Colony5"
          Mode:Managed  Frequency:5.2 GHz  Access Point: A6:91:B1:70:CC:EF
          Bit Rate=26 Mb/s   Tx-Power=22 dBm
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=37/70  Signal level=-73 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:125   Missed beacon:0
```  

If on, run:  
`iwconfig <wifi_device> power off`  

This may be sticky, but if not, you can add the command to your networking init.d startup script [S07network](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/etc/init.d/S07network).  

## Router woes - dropping connections
My Wifi modem/router was set to "auto" channel config.  This meant the router would either change channels or choose a conflicting channel.  In both cases, there would be a disconnect without reconnect on Batocera.  Ensure you change the channel on your router to a static setting.  For me in New Zealand, I used channel 3 and haven't had a problem since.  No changes are needed Batocera side.

## Allocating a static IP
There's no way to do this currently in Batocera, so I hacked in a static IP via connman startup [S08connman](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/etc/init.d/S08connman):  
```
		IPv4=192.168.1.13/255.255.255.0/192.168.1.1
		Nameservers=8.8.8.8,8.8.4.4
		IPv6=off
```  

Also need to set the IP in the /etc/hosts file via [S26system](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/etc/init.d/S26system):  
`        echo "192.168.1.13	${hostname}"          >> /etc/hosts`  

If you are finding SSH session launches slow to prompt with login, this is likely due to DNS failure on your local network from Batocera, trying to resolve the device you are connecting from.  A hack is to add your client's IP and hostname to the /etc/hosts (via the same script above).  

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

samba maintains its own user/password list, so you may need to run:  
`smbpasswd -a root`  

And add root/give a samba password. I can't recall.


