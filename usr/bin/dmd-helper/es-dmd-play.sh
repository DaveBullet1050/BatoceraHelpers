#!/bin/bash

# Plays the requested file but only if the marquee has changed.  Only play in background if a GIF as dmd-play needs to continue, otherwise PNG files it closes once sent to dmdserver.  If the clock is to be displayed, send $1 = "|clock|" and the $2 is the appropriate colour string

progname=${progname}es-dmd-play:

echo "${progname}Requested marquee or text: ${1}" >> ${esScriptLogFile}

newMarquee=${1}

if [ -f ${lastMarqueeFile} ]
then
	lastMarquee=`cat ${lastMarqueeFile}`
else
	lastMarquee=''
fi

if [[ "${newMarquee}" == "${lastMarquee}" ]] && [[ "${newMarquee}" != '|clock|' ]]
then
	echo "${progname}New marquee same as last marquee: ${lastMarquee}.  Hasn't changed, aborting" >> ${esScriptLogFile}
	return
fi

echo "${progname}Marquee has changed, was ${lastMarquee}" >> ${esScriptLogFile}
echo "${newMarquee}" > ${lastMarqueeFile}

# GIFs when played via dmd-play continue to run, rather than a static PNG or text message (where dmd-play runs
# then finishes).  So if there is a saved PID we'll kill it before continuing
if [ -f ${lastDmdPIDFile} ]
then
	dmdPID=`cat ${lastDmdPIDFile}`
	echo "${progname}GIF or clock dmd already playing.  Killing dmd-play PID: ${dmdPID} nicely with SIGINT" >> ${esScriptLogFile}
	kill -s SIGINT ${dmdPID}
	
	# Check it died before proceeding.  Timeout if a problem after 2 seconds
	killed=0
	for i in $(seq 1 4);
	do
		isDead=`ps -ef | awk "/dmd-play/ && /${dmdPID}/" | wc -l`
		# AWK above will count itself.  Result = 2 if the GIF PID is still running
		if [ $isDead -eq 1 ]
		then
			killed=1
			break
		elif [ $i -eq 3 ]
		then
			# Last chance - kill it hard
			echo "${progname}Last chance. Killing dmd-play PID: ${dmdPID} firmly with SIGTERM" >> ${esScriptLogFile}
			kill -s SIGTERM ${dmdPID}
		fi
		sleep 0.5
	done

	if [ $killed -eq 0 ]
	then
		echo "${progname}GIF dmd-play PID: ${dmdPID} could not be killed" >> ${esScriptLogFile}
	else
		rm -f ${lastDmdPIDFile}
	fi
fi

if [[ "${newMarquee}" == *gif ]]
then
	dmd-play -f "${newMarquee}" &
	dmdResult=$?
	dmdPlayPID=$!
	echo "${dmdPlayPID}" > ${lastDmdPIDFile}
	echo "${progname}Marquee is GIF.  Launched via dmd-play in background, storing PID: ${dmdPlayPID}.  dmd-play exit code: ${dmdResult}" >> ${esScriptLogFile}

elif [[ "${newMarquee}" == *png ]]
then
	dmd-play -f "${newMarquee}"
	dmdResult=$?
	echo "${progname}Marquee is PNG. Playing via dmd-play.  dmd-play exit code: ${dmdResult}" >> ${esScriptLogFile}

elif [[ $1 == "|clock|" ]]
then
	# case $2 in
		# blue)
			# # Blue
			# colour="-r 0 -g 0 -b 255"
		# ;;
		# red)
			# # Red
			# colour="-r 255 -g 0 -b 0"
		# ;;
		# green)
			# # Green
			# colour="-r 0 -g 255 -b 0"
		# ;;
		# magenta)
			# # Magenta
			# colour="-r 255 -g 0 -b 255"
		# ;;
		# white)
			# # White
			# colour="-r 255 -g 255 -b 255"
		# ;;
		# orange)
			# # Orange
			# colour="-r 255 -g 80 -b 0"
		# ;;
		# yellow)
			# # Yellow
			# colour="-r 255 -g 255 -b 0"
		# ;;
		# cyan)
			# # Cyan
			# colour="-r 0 -g 255 -b 255"
		# ;;
		# purple)
			# # Purple
			# colour="-r 160 -g 10 -b 240"
		# ;;
	# esac

	dmd-play -c --h12 -s 100 -ccc &
	dmdPlayPID=$!
	echo "${dmdPlayPID}" > ${lastDmdPIDFile}
	echo "${progname}Marquee is clock, storing PID: ${dmdPlayPID} for clock marquee then playing via dmd-play in background" >> ${esScriptLogFile}

elif [[ $1 == "|clear|" ]]
then
	echo "${progname}Clearing Marquee" >> ${esScriptLogFile}
	dmd-play --clear
	# Sometimes the first call doesn't work - send it again
	dmd-play -f /userdata/system/dmd/black.png
	
else
	echo "${progname}Marquee is text. Playing via dmd-play" >> ${esScriptLogFile}
	# Assume argument is text
	dmd-play -t "${newMarquee}"
fi

