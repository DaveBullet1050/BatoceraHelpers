#!/bin/bash
#
# Will set the marquee of the game on launch and revert to the system when the game stops
# only if dmd.change.select=yes is not set in batocera.conf

source dmd-set-vars.sh

[[ -n ${changeOnSelect} ]] && exit 0

case $1 in
    gameStart)
		debug "Change marquee on game launch. Game: ${5}"
		source "$esScriptDir"/game-selected/dmd-simulator.sh ${2} "${5}" " " forced
    ;;
	gameStop)
		# Restore the previous system or game marquee
		debug "Restore marquee on game stop"
		source dmd-restore-last-event.sh
	;;
esac
