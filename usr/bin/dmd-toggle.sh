#!/bin/bash

# Toggles marquee DMD display on or off either:
# If any argument passed, will clearing the screen (if turning off)
# Otherwise no argument passed will restore the last event

source dmd-set-vars.sh

debug "STARTED.  Toggle changing?: $1"

if [ -f /tmp/dmd-off ]
then
	if ! [ -z $1 ]
	then
		debug "Enabling DMD panel events and restoring last marquee (if set)"
		rm -f /tmp/dmd-off
		# Restore the previous system or game marquee
		source dmd-restore-last-event.sh
	else
		debug "Toggle not changed, just clearing screen"
		source dmd-play-if-changed.sh '|clear|'
	fi
	
else
	if ! [ -z $1 ]
	then
		debug "Clearing DMD panel and disabling events"
		touch /tmp/dmd-off
		source dmd-play-if-changed.sh '|clear|'
	else
		debug "Toggle not changed, just restoring previous marquee (if any)"
		# Restore the previous system or game marquee
		source dmd-restore-last-event.sh
	fi
fi
