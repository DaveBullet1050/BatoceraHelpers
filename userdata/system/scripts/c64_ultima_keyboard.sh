#!/bin/bash

# Switches in / out a custom C64 keymap file, so that normal cursor up/down/left/right arrow keys
# map to the default ultima direction keys being @ / : ; respectively.  Those keys will still work
# i.e. you have 2 options to move the character. 

# Debugging (optional). Uncomment /tmp/game_start_stop.log and comment the /dev/null line
# if you want to debug
#logfile='/dev/null'
logfile='/tmp/game_start_stop.log'

echo >> ${logfile}

progname=`basename ${0}`
echo LAUNCHED: ${progname} on `date +%x' '%X` >> ${logfile}

echo Command line from Batocera: "$@" >> ${logfile}
scriptPath=`dirname -- ${0}`
# Get the ROM name (without path)
romName=`basename \`dirname "${5}"\``/`basename "${5}"`
echo \$romName: $romName >> ${logfile}

if [ $2 != 'c64' ]
then
	echo "Not a C64 game, exiting." >> ${logfile}
	# Nothing to do if not a c64 game
	exit
fi

# For all C64 games, remove the curr_disk.txt index file
rm /tmp/curr_disk.txt > /dev/null 2>&1

case $1 in
    gameStart)
		if [[ $romName == c64/Ultima* ]]
		then
			# Use special Ultima mapping
			echo 'C64 Ultima starting - switching to Ultima key map' >> ${logfile}
			cp /userdata/bios/vice/C64/sdl_pos.vkm.ultima /userdata/bios/vice/C64/sdl_pos.vkm > /dev/null 2>&1
			
			# Also enable keypad keys 1-4 to change disks
			echo 'Switching multimedia.conf keys to Ultima for disk swap and restarting triggerhappy daemon.' >> ${logfile}
			cp /userdata/system/configs/multimedia_keys.conf.ultima /userdata/system/configs/multimedia_keys.conf > /dev/null 2>&1
			# And restart triggerhappy daemon to load new keys
			/etc/init.d/S50triggerhappy restart >> ${logfile}
		else
			echo 'C64 Game not Ultima - switching to default key map' >> ${logfile}
			# Return the key mapping to C64 defaults
			cp /userdata/bios/vice/C64/sdl_pos.vkm.default /userdata/bios/vice/C64/sdl_pos.vkm >> ${logfile}
		fi
	;;
	gameStop)
		echo 'C64 game stopping - reverting to default keymap' >> ${logfile}
		cp /userdata/bios/vice/C64/sdl_pos.vkm.default /userdata/bios/vice/C64/sdl_pos.vkm >> ${logfile}

		if [[ $romName == c64/Ultima* ]]
		then
			# Also revert keypad to normal operation
			echo 'Reverting multimedia.conf keys to default and restarting triggerhappy daemon.' >> ${logfile}
			cp /userdata/system/configs/multimedia_keys.conf.default /userdata/system/configs/multimedia_keys.conf > /dev/null 2>&1
			# And restart triggerhappy daemon to load new keys
			/etc/init.d/S50triggerhappy restart >> ${logfile}
		fi
	;;
esac