# Batocera backup

Batocera's inbuilt backup works well, however it has 2 issues which I hacked into a custom [batocera-sync](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/bin/batocera-sync) script (which performs the backup).  

## Ignore symbolic links
First issue is symbolic links cause errors when backing up to media that isn't symlink capable (e.g. exFAT formatted).  To solve this, I added:  
`--no-links`  
to the rsync command, to not copy any symbolic links.  The reason I did this is any error from rsync will cause ES to display "backup failed" message, even if everything else worked. I didn't want this bogus error masking an actual failure (e.g. read error or backup disk full).  

Why do I ignore symbolic links?  Well the Daphne emulator adds a:
`/userdata/system/configs/daphne/singe -> /userdata/roms/daphne/roms`  
symbolic link on emulator startup (if missing) and this was causing the rsync error.

## Include overlay file
The other thing I did was include the overlay file in the backup process.  This is stored in /boot/boot/overlay and is not backed up with the userdata backup.  I want my whole system in one backup process so I included this step in batocera-sync before rsync is called (requires /userdata/backup directory to be created):  
```
	# Backup overlay file.  We back it up to /userdata/backup so it is included in the rsync below rather than keep as a separate file
	cp /boot/boot/overlay /userdata/backup 2>&1
```  
