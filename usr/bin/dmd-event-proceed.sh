#!/bin/bash
#
# dmd-event-proceed.sh
#
# This script is called from either game selected or system selected ES event scripts to see if either of those events should proceed, by doing a number of things first
# 1. sets variables for all scripts to use
# 2. checks to see if there has been an event change (or same event triggered twice (and therefore no change required)
# 3. the user has settled on a system or event to display the marquee
# 
# Args:
# $1 - name of calling script
# $2 - name of system (e.g. c64, mame) OR fully qualified path to game rom (e.g. /userdata/roms/c20/Road Race(NTSC)[CG].prg)
# $3 - name of event - system-selected or game-selected (for logging purposes)
#
# Returns:
# 0 - proceed to change marquee (mutex created - must be removed by caller when done changing marquee)
# 1 - abort change

# Set file locations and PATH
source dmd-set-vars.sh

script="${1}"
currSystem="${2}"
currEvent="${3}"
isForced="${4}"

progname=${progname}${script}:

debug "STARTED.  currSystem: ${currSystem}, currEvent: ${currEvent}, is forced: ${isForced}"

# Check if we've recorded the current game or system yet, if not initialise the variables
source dmd-get-last-event.sh

# Abort if event called twice and system still the same, unless we've been told to force setting the marquee (e.g. returning from screensaver)
if [ $? -eq 0 ] && ! [[ -n ${isForced} ]]
then
	debug "same as last event, aborting"
	return 1
fi

# Regardless of what happens, store this game/system (and current script PID) as the latest event
source dmd-store-last-event.sh "${script}" "${currSystem}" "${currEvent}"

# Check if DMD display is toggled off. If so, abort
if [ -f /tmp/dmd-off ]
then
	debug "DMD display is set to off, exiting"
	return 1
fi

# Check if game marquee is only meant to be displayed at game launch. If so then only change
# the system marquee if the system has changed (which it can if user jumps across systems when viewing
# the game list)
if [[ -z ${isForced} ]] && [[ -z ${changeOnSelect} ]] && [[ ${script} == "game-selected" ]]
then
	if [[ ${lastSystem} == ${currSystem} ]]
	then
		debug "Game marquee on launch only. No system change, so aborting"
	else
		debug "Game marquee on launch only but system has changed from: ${lastSystem} to: ${currSystem}.  Display the system marquee change"
		source "$esScriptDir"/system-selected/dmd-simulator.sh ${currSystem} forced
	fi
	return 1
fi

# Wait configured seconds (see dmd-set-vars.sh for value) to see if the user settles (still on same game/system or user has moved again
# Check the event name hasn't changed again (i.e superceded call with user moving again)
sleep ${changeWaitTime}
source dmd-get-last-event.sh

# This should be the same, as we store the current game/system to become the last.  If different, another event has occurred
if [ $? -eq 2 ]
then
	debug "Another script has run with new event: ${lastEvent} and PID: ${lastSelectedScriptPid}, supercedeeding this event, aborting"
	return 1
fi

# If we are using dmd-play as a service and sending commands (instead of instancing dmd-play per system
# or game change) then no mutex required
if [[ -n ${playAsService} ]]
then
	return 0
fi

# We're running dmd-play interactively (per change).
# We'll change the marquee, but make sure there is no dmd-play still running, waiting 5 secs for completion
noMutex=0
for i in {1..10}
do
	# Only wait for the mutex if we haven't been superceeded
	source dmd-get-last-event.sh
	if [ $? -gt 1 ]
	then
		debug "Whilst waiting for mutex, another script has run with new event: ${lastEvent} and PID: ${lastSelectedScriptPid}, supercedeeding this event, aborting"
		return 1

	elif [ -d /tmp/dmd-mutex ]
	then
		debug "Mutex found. A previous script is still changing the marquee, waiting, attempt: $i"

	else
		# Ok - no other user navigation has occurred to change the game/system AND no dmd-play is running.  We'll grab control by creating a mutex... simply by creating a directory (atomic operation)
		mkdir /tmp/dmd-mutex > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			debug "Created mutex (/tmp/dmd-mutex directory)"
			noMutex=1
			break
		else
			debug "${progname}Error creating mutex (/tmp/dmd-mutex directory). Another event may have just grabbed it (race condition), aborting"
			return 1
		fi
	fi
	sleep 0.5
done

# If the mutex hasn't been released by the other process, we give up
if [ ${noMutex} -eq 0 ]
then
	debug "Another script: ${lastEvent} and PID: ${lastSelectedScriptPid} is still changing the marquee.  Wait time exceeded, aborting"
	return 1
fi

return 0