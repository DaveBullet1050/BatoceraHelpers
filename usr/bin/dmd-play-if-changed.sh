#!/bin/bash

# Plays the requested marquee file but only if the marquee has changed (or clock is requested)

progname=${progname}dmd-play-if-changed.sh:

debug "Requested marquee or text: ${1}"

newMarquee=${1}

if [ -f ${lastMarqueeFile} ]
then
	lastMarquee=`cat ${lastMarqueeFile}`
else
	lastMarquee=''
fi

if [[ "${newMarquee}" == "${lastMarquee}" ]] && [[ "${newMarquee}" != '|clock|' ]]
then
	debug "New marquee same as last marquee: ${lastMarquee}.  Hasn't changed, aborting"
	return
fi

debug "Marquee has changed, was ${lastMarquee}, now ${newMarquee}. Sending command via dmd-play-launcher.sh"
echo "${newMarquee}" > ${lastMarqueeFile}

if [[ ${newMarquee} == "|clock|" ]] || [[ ${newMarquee} == "|clear|" ]]
then
	source dmd-play-launcher.sh "${newMarquee}"

elif [ -f "${newMarquee}" ]
then
	debug "Marquee is GIF or PNG. Sending command via dmd-play-launcher.sh"
	source dmd-play-launcher.sh file "${newMarquee}"

else
	debug "Marquee is text. Sending command via dmd-play-launcher.sh"
	# Assume argument is text
	source dmd-play-launcher.sh text "${newMarquee}"
fi

