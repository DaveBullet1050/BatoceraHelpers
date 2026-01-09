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

This may be sticky, but if not, you can add the command to your networking init.d startup script [S07network](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/etc/init.d/S07network).  Remember to run: `batocera-save-overlay`  to persist the script edit between reboots.  

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
`        echo "192.168.1.13	`hostname`"          >> /etc/hosts`  

If you are finding SSH session launches slow to prompt with login, this is likely due to DNS failure on your local network from Batocera, trying to resolve the device you are connecting from.  A hack is to add your client's IP and hostname to the /etc/hosts (via the same script above):  
`        echo "<your_client_ip>	<your_client_hostname>"          >> /etc/hosts`  
eg:  
`        echo "192.168.1.11 DAVID-LAPTOP" >> /etc/hosts`  


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

You can then browse from Windows explorer for example via:  
`\\batocera.local\root`  

## My batocera machine still won't connect, what do I do?  
Batocera uses connman for networking which relies on wpa_supplicant for Wifi authentication.  The ArchLinux wiki is very useful, check out the connman and wpa_supplicant guides for the command line to troubleshoot and also location of config files, to check settings:  

https://wiki.archlinux.org/title/ConnMan  
https://wiki.archlinux.org/title/Wpa_supplicant  

Plug in a keyboard and press Ctrl-Alt-F3 or F1 to bring up the console terminal. 

Run:  
`dmesg | grep wlan`
  
and look for network related events.  Here's an example of my log for a successful sequence:  
```
[    2.731995] iwlwifi 0000:02:00.0 wlan126: renamed from wlan0
[    2.732986] udevd[498]: renamed network interface wlan0 to wlan126
[    2.732993] iwlwifi 0000:02:00.0 wlan2: renamed from wlan126
[    2.733030] udevd[498]: renamed network interface wlan126 to wlan2
[   21.007122] wlan2: authenticate with a6:91:b1:70:cc:ef (local address=f0:d4:15:d6:08:c6)
[   21.008546] wlan2: send auth to a6:91:b1:70:cc:ef (try 1/3)
[   21.048359] wlan2: authenticated
[   21.050537] wlan2: associate with a6:91:b1:70:cc:ef (try 1/3)
[   21.059924] wlan2: RX AssocResp from a6:91:b1:70:cc:ef (capab=0x1511 status=0 aid=108)
[   21.070589] wlan2: associated
[   21.152473] wlan2: Limiting TX power to 23 (23 - 0) dBm as advertised by a6:91:b1:70:cc:ef
```  

Run:  
`iwconfig`  

and check your wifi card is listed - e.g. wlan2 or similar.  Check power management is set to off.  Whilst this won't cause connection issues it may cause drop outs with sleep modes.  

Run:  
`ip addr`  

check your wifi adapter contains UP in the first line, eg:  
```  
 2: wlan2: <BROADCAST,MULTICAST,DYNAMIC,UP,LOWER\_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
link/ether f0:d4:15:d6:08:c6 brd ff:ff:ff:ff:ff:ff
inet 192.168.1.16/24 brd 192.168.1.255 scope global wlan2
valid\_lft forever preferred\_lft forever
```

If down, run (replacing your device name if needed):  
`ip link set wlan2 up`  

Run this:  
`ps -ef | grep -e conn -e wpa`  

An check both services are running, eg:  
```
root       900     1  0 07:23 ?        00:00:00 /usr/sbin/connmand -n -r
root       942     1  0 07:23 ?        00:00:00 /usr/sbin/wpa_supplicant -u
root      5727  2657  0 07:38 pts/0    00:00:00 grep -e conn -e wpa
```

If both services are running, follow the ArchLinux Wiki links (above) to troubleshoot by manually scanning for networks and connecting using connmanctl.  This should show an error interactively to help with troubleshooting.  
