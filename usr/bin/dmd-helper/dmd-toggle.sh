#!/bin/bash

# Toggles marquee DMD display on or off

source /usr/bin/dmd-helper/es-set-vars.sh

progname=$(basename "$(readlink -f ${0})"):dmd-toggle:

echo >> ${esScriptLogFile}
echo "${progname}STARTED.  Toggle passed?: $1" >> ${esScriptLogFile}

if [ -f /tmp/dmd-off ]
then
	if ! [ -z $1 ]
	then
		echo "${progname}Enabling DMD panel events and restoring last marquee (if set)" >> ${esScriptLogFile}
		rm -f /tmp/dmd-off
		# Restore the previous system or game marquee
		source es-restore-last-event.sh
	else
		echo "${progname}Toggle not changed, just clearing screen" >> ${esScriptLogFile}
		source es-dmd-play.sh '|clear|'

	fi
	
else
	if ! [ -z $1 ]
	then
		echo "${progname}Clearing DMD panel and disabling events" >> ${esScriptLogFile}
		touch /tmp/dmd-off
		source es-dmd-play.sh '|clear|'
	else
		echo "${progname}Toggle not changed, just restoring previous marquee (if any)" >> ${esScriptLogFile}
		# Restore the previous system or game marquee
		source es-restore-last-event.sh
	
	fi
fi
