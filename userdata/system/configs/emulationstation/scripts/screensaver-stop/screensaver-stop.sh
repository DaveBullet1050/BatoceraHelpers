#!/bin/bash

source dmd-set-vars.sh

debug "STARTED.  Screensaver ending"

# Check if DMD display is toggled off. If so, abort
if [ -f /tmp/dmd-off ]
then
	debug "DMD display is set to off, exiting"
	return 1
else
	# Restore the previous system or game marquee
	source dmd-restore-last-event.sh
fi
