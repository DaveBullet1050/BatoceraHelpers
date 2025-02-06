#!/bin/bash
#
# es-event-proceed.sh
#
# This script is called from either game selected or system selected ES event scripts to see if either of those events should proceed, by doing a number of things first
# 1. sets variables for all scripts to use
# 2. checks to see if there has been an event change (or same event triggered twice (and therefore no change required)
# 3. the user has settled on a system or event to display the marquee
# 4. if the user has settled, whether a previous script is holding the mutex (and waiting a few seconds)
# 5. If no mutex or after waiting it has been released, then tries to acquire the mutex (error if it can't - i.e. race condition with another thread)
# 
# Args:
# $1 - name of system (e.g. c64, mame) OR fully qualified path to game rom (e.g. /userdata/roms/c20/Road Race(NTSC)[CG].prg)
# $2 - name of event - system-selected or game-selected (for logging purposes)
#
# Returns:
# 0 - proceed to change marquee (mutex created - must be removed by caller when done changing marquee)
# 1 - abort change

# Set file locations and PATH
source /usr/bin/dmd-helper/es-set-vars.sh

script="${1}"
system="${2}"
currEvent="${3}"
isForced="${4}"

# ES launches /var/run/emulationstation/scripts/system-selected/dmd-server.sh which is a sym link to
# /usr/share/dmd-simulator/scripts/system-selected.sh.  readlink allows us to resolve the symlink
# and return "system-selected.sh" as the progname (instead of the generic dmd-server.sh). Only used
# for logging (so we can distinguish between game started and system selected events
progname=$(basename "$(readlink -f ${0})"):$BASHPID:${script}:${currEvent}:

echo >> ${esScriptLogFile}
echo "${progname}STARTED.  system: ${system}, event: ${currEvent}, is forced: ${isForced}" >> ${esScriptLogFile}

# Check if we've recorded the current game or system yet, if not initialise the variables
source es-get-last-event.sh

# Abort if event called twice and system still the same, unless we've been told to force setting the marquee (e.g. returning from screensaver)
if [ $? -eq 0 ] && ! [[ -n ${isForced} ]]
then
	echo "${progname}same as last event, aborting" >> ${esScriptLogFile}
	return 1
fi

# Regardless of what happens, store this game/system (and current script PID) as the latest event
source es-store-last-event.sh "${script}" "${system}" "${currEvent}"

# Check if DMD display is toggled off. If so, clear the display
if [ -f /tmp/dmd-off ]
then
	echo "${progname}DMD display is set to off, exiting" >> ${esScriptLogFile}
	return 1
fi

# Wait 1.5 seconds to see if the user settles (still on same game/system or user has moved again
# Check the event name hasn't changed again (i.e superceded call with user moving again)
sleep ${waitTime}
source es-get-last-event.sh

# This should be the same, as we store the current game/system to become the last.  If different, another event has occurred
if [ $? -eq 2 ]
then
	echo "${progname}Another script has run with new event: ${lastEvent} and PID: ${lastSelectedScriptPid}, supercedeeding this event, aborting" >> ${esScriptLogFile}
	return 1
fi

# We'll change the marquee, but make sure there is no dmd-play still running, waiting 5 secs for completion
noMutex=0
for i in $(seq 1 10);
do
	# Only wait for the mutex if we haven't been superceeded
	source es-get-last-event.sh
	if [ $? -gt 1 ]
	then
		echo "${progname}Whilst waiting for mutex, another script has run with new event: ${lastEvent} and PID: ${lastSelectedScriptPid}, supercedeeding this event, aborting" >> ${esScriptLogFile}
		return 1

	elif [ -d /tmp/dmd-mutex ]
	then
		echo "${progname}Mutex found. A previous script is still changing the marquee, waiting" >> ${esScriptLogFile}

	else
		# Ok - no other user navigation has occurred to change the game/system AND no dmd-play is running.  We'll grab control by creating a mutex... simply by creating a directory (atomic operation)
		mkdir /tmp/dmd-mutex > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo "${progname}Created mutex (/tmp/dmd-mutex directory)" >> ${esScriptLogFile}
			noMutex=1
			break
		else
			echo "${progname}Error creating mutex (/tmp/dmd-mutex directory). Another event may have just grabbed it (race condition), aborting" >> ${esScriptLogFile}
			return 1
		fi
	fi
	sleep 1
done

# If the mutex hasn't been released by the other process, we give up
if [ ${noMutex} -eq 0 ]
then
	echo "${progname}Another script: ${lastEvent} and PID: ${lastSelectedScriptPid} is still changing the marquee.  Wait time exceeded, aborting" >> ${esScriptLogFile}
	return 1
fi

return 0