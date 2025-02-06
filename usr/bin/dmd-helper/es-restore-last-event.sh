#!/bin/bash

# Restore the previous system or game marquee
source es-get-last-event.sh

if [[ -n "${lastEvent}" ]]
then
	echo "${progname}Loading previous marquee for system: ${lastSystem}, for last event: ${lastEvent}" >> ${esScriptLogFile}
	if [[ ${lastScript} == game-selected ]]
	then
		source /userdata/system/configs/emulationstation/scripts/game-selected/dmd-simulator.sh	"${lastSystem}" "${lastEvent}" " " forced
	else
		source /userdata/system/configs/emulationstation/scripts/system-selected/dmd-simulator.sh "${lastSystem}" force
	fi
fi