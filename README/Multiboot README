# Multiple versions of Batocera

The [wiki](https://wiki.batocera.org/dual_boot_ubuntu_batocera.linux) does a good job at showing how to dual boot with either another Linux distribution or Windows.  I wanted to dual boot multiple Batocera installations using GRUB. 

The caveat here is my drive that contains the boot partition (EFI) is owned by Arch Linux.  I use [GRUB](https://wiki.archlinux.org/title/GRUB) and have a fat32 EFI setup with a grub menu for all of my O/Ses.  

## Batocera file systems
Batocera comprises 2 partitions:  
1. BATOCERA = a (normally) fat32 / EFI partition containing the linux kernal, 'squashfs" image of all of the Batocera system (binaries, emulators, configgen etc...)  
2. SHARE = your /userdata and all your roms, bioses, save states, custom configuration, ES settings etc...

By default, when you install batocera, the first partition is named "BATOCERA".  Batocera uses syslinux as a boot loader and the label of the root partition is passed to the linux image booted.  This helps Batocera "find" it's boot partition so it can then find the SHARE partition.  Batocera can be pointed to an external or an internal SHARE partition.  By default, internal SHARE is assumed, and Batocera assumes this is the next partition after BATOCERA (it doesn't care about the partition label or type or size).

So what happens when want to have multiple different batocera's booting?  Well - they clash because they all have the same "BATOCERA" boot partition.  Batocera will find always find the first BATOCERA labeled file system then use the next one as the internal SHARE.  We need a way of segregating the different Batocera instances, so they boot with the correct boot partitions and therefore index and find the correct "next" partition, containing the correct SHARE.  

## Renaming multiple instances
Batocera uses syslinux as a boot loader.  Rather than needing to install another bootloader (rEFInd or GRUB for example), we can configure one Batocera to be the boot loader for all (and anything else on the system).  Most of the content comes from the brilliant [Arch Linux wiki](https://wiki.archlinux.org/title/Syslinux)

You can keep the name of one of your Batocera instances as BATOCERA, as long as they each have a different name to locate them and pass the label / name to the Kernel when it boots.  For clarity, I decided to rename each of mine, in this case one on the NVMe drive and the other on a SATA drive, but you can use any names you like
