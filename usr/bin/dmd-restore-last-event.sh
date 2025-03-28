#!/bin/bash

# Restore the previous system or game marquee.  This is called usually when a game ends
source dmd-get-last-event.sh

if [[ -n "${lastEvent}" ]]
then
	debug "Loading previous marquee for last script: ${lastScript} last system: ${lastSystem}, for last last event: ${lastEvent}"
	if [[ -n ${changeOnSelect} ]] && [[ ${lastScript} == "game-selected" ]]
	then
		source "$esScriptDir"/game-selected/dmd-simulator.sh "${lastSystem}" "${lastEvent}" " " forced
	else
		source "$esScriptDir"/system-selected/dmd-simulator.sh "${lastSystem}" forced
	fi
fi