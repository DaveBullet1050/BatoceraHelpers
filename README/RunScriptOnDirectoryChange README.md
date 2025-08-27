# Running a script when a directory changes - useful to keep custom collections in sync

I didn't like having separate Daphne and MAME collections.  For me, they are all "Arcade" games.  It's easy enough to setup a custom collection in BAtocera (START -> GAME COLLECTION SETTINGS -> CREATE NEW EDITABLE COLLECTION), but then every time I added a MAME or Daphne ROM, I would run START -> GAME SETTINGS -> UPDATE GAME LISTS, but forget to add these games to my custom collection .cfg file.  

I created 3 scripts to do the job:  
`/usr/bin/update-arcade-collection` - this simply dumps the contents of the MAME and Daphne roms into the custom "Arcade" .cfg file, therefore updating the collection  
`/usr/bin/notify-roms-changed` - this background process monitors the contents of the Daphne and MAME roms directories. If a rom is added (or removed) then this script runs `/usr/bin/update-arcade-collection`  
`/userdata/system/services/notify-roms-changed` - this launches or stops the `/usr/bin/notify-roms-changed` as a background process. The service appears in ES under START -> SYSTEM SETTINGS -> SERVICES, so you can toggle the service on or off  
