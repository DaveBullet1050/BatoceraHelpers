#!/bin/bash
#
# ES system-selected event
#
# Updates the marquee with an image for the system selected.  This is called by ES but
# only on the main system list.  We only update the marquee if:
# a) there has been a change, as ES sometimes calls this twice and we don't want to waste time re-updating the marquee
# b) the system hasn't been changed in >= 1.5 seconds, if so it means the user is not flicking through systems or game lists and has landed on the system they are likely to play a game from
# c) there aren't any running /usr/bin/dmd-play processes. If there are, we will wait until they are finished then update the marquee (one at a time), but only there hasn't been a system change in the meantime

# Args:
# $1 - name of system (e.g. c64, c20, mame)

# This script sets variables and does the checking to see if there has been an event change, whether
# the user has settled on a system or event to display the marquee, whether another script is holding
# the mutex (and waiting a few seconds) before finally acquiring the mutex or aborting
# 

currSystem="$1"
currEvent="$1"
forced="$2"

# Only proceed to change marquee if the user has settled on the system and there isn't another event that has superceeded this instance
source /usr/bin/dmd-helper/es-event-proceed.sh 'system-selected' "${currSystem}" "${currEvent}" "${forced}"
if [ $? -ne 0 ]; then exit; fi

# Ok - safe to proceed to change the system Marquee!
echo "${progname}CHANGING MARQUEE" >> ${esScriptLogFile}

# System name has changed.  Find where the marquee images are sourced
LOGO=$(wget "http://localhost:1234/systems/${currSystem}?localpaths=true" -qO - | jq -r '.logo')
echo "${progname}LOGO path: ${LOGO}" >> ${esScriptLogFile}

if test -n "${LOGO}" -a -e "${LOGO}"
then
    EXT=$(echo "${LOGO}" | sed -e s+"^.*\.\([^\.]*\)$"+"\1"+)
    if test "${EXT}" = svg
    then
		# use cache here...
		CHASH=$(echo "${LOGO}" | md5sum | cut -c 1-32)
		HPATH="/var/run/dmd-simulator/cache/${CHASH}.png"
		
		if test -e "${HPATH}"
		then
			echo "${progname}Hash file: ${HPATH} found, setting marquee via dmd-play" >> ${esScriptLogFile}
			source es-dmd-play.sh "${HPATH}"
		else
			echo "${progname}Hash file not found.  Attempting to create" >> ${esScriptLogFile}
			mkdir -p "/var/run/dmd-simulator/cache" 
			if rsvg-convert --width=300 --height=300 --keep-aspect-ratio --output="${HPATH}" "${LOGO}" -b black # try to cache
			then
				echo "${progname}Hash file created, setting marquee via dmd-play" >> ${esScriptLogFile}
				source es-dmd-play.sh "${HPATH}"
			fi
		fi
    else
		echo "${progname}No hash file path, playing logo: ${LOGO} direct via dmd-play" >> ${esScriptLogFile}
		source es-dmd-play.sh "${LOGO}"
    fi
else
	# fallback : name
	GNAME=$(wget "http://localhost:1234/systems/${currSystem}?localpaths=true" -qO - | jq -r '.fullname' | txt2http)
	if test -n "${GNAME}"
	then
		echo "${progname}Can't find any image, displaying system name" >> ${esScriptLogFile}
		source es-dmd-play.sh "${lastSystem}"
	else
		echo "${progname}Can't find system name nor image, clearing display" >> ${esScriptLogFile}
		# fallback : empty
		#dmd-play ${DMDOPT} --clear
		# The latest ZeDMD.bin 5.1.1 firmware displays the bright ZeDMD logo when a clear is sent so my hack is to send a black image.  However this black image has one pixel that has RGB(1,1,1) to fool the zedmd into thinking it's a picture (if you send a full 0,0,0 image, then zedmd still thinks its nothing and displays the ZeDMD logo)
		source es-dmd-play.sh /userdata/system/dmd/black.png
	fi
fi

# Finally remove the mutex
echo "${progname}Removing mutex" >> ${esScriptLogFile}
rmdir /tmp/dmd-mutex > /dev/null 2>&1
