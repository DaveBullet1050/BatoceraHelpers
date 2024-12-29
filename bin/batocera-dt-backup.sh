#!/bin/sh
#
# Don't use this.  I've updated batocera-sync which is called from the ES main menu to
# include the overlay file.  The batocera native backup handles deltas much better than this approach
# although it doesn't compress files into one tar/gzip
#
# pass in "create" or "update"
# "create" will overwrite and do a full system backup
# "update" (default) will append/update files that have changed (assuming a backup file
# alreadt exists)

# The native Batocera backup differentially copies /userdata contents to a FAT32/VFAT USB
# drive.  This script does the same but creates a single compressed TAR archive and also
# includes the overlay filesystem (containing / changes) and manually edited /boot config
# files, allowing a full restore of / plus /userdata after installing Batocera v39 again
#
# Assumes the USB stick is mounted on /mnt/usb-drive, e.g. /etc/fstab:
# /dev/sda1	/mnt/usb-drive	vfat	defaults	0	0

#mount -t tmpfs tmpfs /tmp -o size=2000M,mode=1777,remount

if [ "$1"="create" ]
then
	# This will create a new backup file, overwriting the existing - if we use gzip
	# then we can't update / append later. Easiest to just tar uncompressed, then compressed
	# the tar after the fact if desired
	bsdtar --acls --xattrs -cpvf /mnt/usb-drive/batocera_backup /boot/boot/overlay /boot/config.txt /boot/cmdline.txt /userdata
	#bsdtar --acls --xattrs --gzip -cpvf /mnt/usb-drive/batocera_backup /boot/boot/overlay /boot/config.txt /boot/cmdline.txt /userdata
else
	bsdtar --acls --xattrs -upvf /mnt/usb-drive/batocera_backup /boot/boot/overlay /boot/config.txt /boot/cmdline.txt /userdata
fi
