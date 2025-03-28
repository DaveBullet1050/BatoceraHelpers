#!/bin/bash
#
# ES game-selected event
#
# When a game is selected, we want to update the marquee for the game (if an appropriate
# image exists).  We need to wait for the user to settle, as marquee changes are slow
# and we'll bog down the ES UI / Pi if the user is whizzing around.  We'll try a custom marquee
# file on exact rom match (first GIF then PNG extension in /userdata/system/dmd/games/<system>/<rom>
# If not found, we'll query ES for a marquee for the game.  If nothing found, then we'll simply
# revert to displaying the system marquee

# Args:
# $1 - name of system (e.g. c64, c20, mame)
# $2 - Fully qualified filename of rom (e.g. /userdata/roms/c20/Road Race(NTSC)[CG].prg)
# $3 - Display name of rom (e.g. Dragon's Lair)	

currSystem="$1"
currGame="$2"
forced="$4"

# Only proceed to change marquee if the user has settled on the game and there isn't another event that has superceeded this instance
source dmd-event-proceed.sh 'game-selected' "${currSystem}" "${currGame}" "${forced}"
if [ $? -ne 0 ]; then exit; fi

# Ok - safe to proceed to change the game Marquee!
debug "CHANGING GAME MARQUEE for: ${currGame}"

foundImage=0
# Find a custom marque GIF or PNG in /userdata/system/dmd/games/<system>, stripping out special characters
# lowercase and remove any but a-z and 0-9, remove things in parenthesis
GAMEBASE=$(basename "${currGame}")
ROMBASE=$(basename "${currGame}" | sed -e s+"\.[^\.]*$"++)
ROMMIN=$(echo "${ROMBASE}" | sed -e s+"([^)]*)"+""+g -e s+"[^_A-Za-z0-9]"+""+g | tr A-Z a-z) 
for BASE in "/userdata/system/dmd/games/${currSystem}/${ROMMIN}" "/userdata/roms/${currSystem}/images/${ROMBASE}-marquee" "/userdata/roms/${currSystem}/images/${ROMBASE}-image" 
do
	for EXT in gif png
	do
		CUS=${BASE}.${EXT}
		debug "Looking for custom marquee image: ${CUS}"
	
		if test -e "${CUS}"
		then
			debug "Found custom marquee image: ${CUS}, playing via dmd-play"
			foundImage=1
			source dmd-play-if-changed.sh "${CUS}"
			break
		fi
	done
	if [ $foundImage -eq 1 ]
	then
		break
	fi
done

if [ -z ${playAsService} ]
then
	# If running interactively, remove the  mutex
	debug "Game change: ${currGame}, finished.  Removing mutex"
	rmdir /tmp/dmd-mutex > /dev/null 2>&1
fi

if [ $foundImage -eq 0 ]
then
	debug "Couldn't find custom nor ES sourced marquee, just display the system marquee for: ${currSystem}"
	source "${esScriptDir}"/system-selected/dmd-simulator.sh ${currSystem}
fi