#!/bin/bash

# ES screensaver-start
#
# Display a clock in a random colour if dmd.screensaver=clock, otherwise default behaviour

# Set file locations and PATH
source dmd-set-vars.sh

if [[ -n ${clockScreenSaver} ]]
then
	# Check if DMD display is toggled off. If so, abort
	if [ -f /tmp/dmd-off ]
	then
		debug "DMD display is set to off, exiting"
		exit 1
	else
		debug "STARTED.  Playing clock"
		source dmd-play-if-changed.sh '|clock|'
		exit 0
	fi
	
else
	# Default behaviour - play custom screensaver, failing that, play the batocera logo
	# custom
	for EXT in gif png
	do
		CUS="/userdata/system/dmd/screensaver.${EXT}"
		if test -e "${CUS}"
		then
			source dmd-play-if-changed.sh "${CUS}"
		exit 0
		fi
	done

	source dmd-play-if-changed.sh "/usr/share/dmd-simulator/images/system/batocera.png"
	exit 0
fi
