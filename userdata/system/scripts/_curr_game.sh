#!/bin/sh

# Get the ROM name.  This is the romname prefixed by the directory (emulator) it is in - e.g. mame/puckman.zip
romName=`basename \`dirname "${5}"\``/`basename "${5}"`

# Batocera tells us the event, we're only interested in games starting or stopping.
case $1 in
    gameStart)
		# Store the ROM name as the current game for querying in other scripts
		echo $romName > /tmp/curr_game
    ;;
	gameStop)
		# Remove currently playing game now it is stopping
		rm /tmp/curr_game > /dev/null 2>&1
	;;
esac

exit 0