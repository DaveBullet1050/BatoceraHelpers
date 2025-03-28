#!/bin/bash

# Send a command to dmd-play.  if configured to use the dmd-play server (batocera.conf dmd.play.mode=service)
# then send the command over a TCP socket to the dmd-play listener port
# $1 = command, either:
#		|clock| = display the clock and colour cycle
#		|clear| = clear the DMD
#		file = display the filename (GIF or PNG)
#		text = display the text
# $2 = fully qualifed filename or text to display

#source dmd-set-vars.sh

dmdPlayOpts=
if [[ $1 == "|clock|" ]]
then
	debug "Marquee is clock"
	dmdPlayCmd="-c --h12 -s 100 -ccc"

elif [[ $1 == "|clear|" ]]
then
	debug "Clearing Marquee"
	dmdPlayCmd="--clear"

elif [[ $1 == "file" ]]
then
	debug "Marquee is file"
	dmdPlayOpts="-f "
	dmdPlayCmd=${@:2}

elif [[ $1 == "text" ]]
then
	debug "Marquee is text"
	dmdPlayOpts="-t "
	dmdPlayCmd=${@:2}

else
	debug "Command: $1 unknown.  Aborting"
fi

dmdPlayHD=
dmdFormat=$(batocera-settings-get dmd.format)

if [[ -n ${playAsService} ]]
then
	debug "dmd-play as service"
	if [[ -f ${dmdPlayServicePIDFile} ]]
	then
		dmdPlayServicePID=`cat ${dmdPlayServicePIDFile}`
		debug "Sending SIGINT to dmd-play service PID: ${dmdPlayServicePID}"
		kill -s SIGINT ${dmdPlayServicePID}
	else
		debug "dmd-play service PID file: dmdPlayServicePIDFile doesn't exist for dmd-play service, cannot send signal to terminate current media. New marquee may not play"
	fi

	[[ ${dmdFormat} == "hd" ]] && dmdPlayHD="--hd "
	if [[ -z ${playRepeat} ]] && [[ "$dmdPlayCmd" == *gif ]]
	then
		dmdPlayOnce="--once "
	fi
	if [[ $1 == "file" ]] || [[ $1 == "text" ]]
	then
		dmdPlayCmd=\"${dmdPlayCmd}\"
	fi
	fullCmd=${dmdPlayHD}${dmdPlayOnce}${dmdPlayOpts}${dmdPlayCmd}
	debug "Sending marquee command: ${fullCmd} to dmd-play port: ${playPort}"
	echo -n ${fullCmd} | nc -c -w1 127.0.0.1 ${playPort}

else
	debug "dmd-play interactively"
	[[ ${dmdFormat} == "hd" ]] && dmdPlayHD="--hd"
	if [ -f ${dmdPlayPIDFile} ]
	then
		# This is a GIF continuously running in the background, kill it so we can replace
		# the media
		dmdPlayPID=`cat ${dmdPlayPIDFile}`
		debug "GIF playing. Killing dmd-play PID: ${dmdPlayPID} nicely with SIGINT..."
		kill -s SIGINT ${dmdPlayPID}
		
		if [ $? -eq 1 ]
		then
			# Process doesn't exist
			killed=1
		else
			# Check it died before proceeding.  Timeout if a problem after 2 seconds
			killed=0
			for i in {1..4}
			do
				isDead=`ps -ef | awk "/dmd-play/ && /${dmdPlayPID}/" | wc -l`
				# AWK above will count itself.  Result = 2 if the GIF PID is still running
				if [ $isDead -eq 1 ]
				then
					killed=1
					break
				elif [ $i -eq 3 ]
				then
					# Last chance - kill it hard
					debug "Last chance. Killing dmd-play PID: ${dmdPlayPID} firmly with SIGTERM"
					kill -s SIGTERM ${dmdPlayPID}
				fi
				sleep 0.5
			done
		fi

		if [ $killed -eq 0 ]
		then
			debug "GIF dmd-play PID: ${dmdPlayPID} could not be killed"
		else
			rm -f ${dmdPlayPIDFile}
		fi
	fi

	if [[ "$dmdPlayCmd" == *gif ]]
	then
		[[ -z ${playRepeat} ]] && dmdPlayOnce="--once"
		dmd-play ${dmdPlayHD} ${dmdPlayOnce} -f ${dmdPlayCmd} &
		dmdResult=$?
		dmdPlayPID=$!
		echo ${dmdPlayPID} > ${dmdPlayPIDFile}
		debug "Marquee is GIF.  Launched dmd-play in background with command: ${dmdPlayHD} ${dmdPlayOnce} -f ${dmdPlayCmd}, storing PID: ${dmdPlayPID} in ${dmdPlayPIDFile}.  dmd-play exit code: ${dmdResult}"

	elif [[ "$dmdPlayCmd" == *png ]]
	then
		dmd-play ${dmdPlayHD} -f ${dmdPlayCmd}
		dmdResult=$?
		debug "Marquee is PNG. Played via dmd-play with command: ${dmdPlayHD} -f ${dmdPlayCmd}.  dmd-play exit code: ${dmdResult}"

	elif [[ $1 == "|clock|" ]]
	then
		dmd-play ${dmdPlayHD} ${dmdPlayCmd} &
		dmdResult=$?
		dmdPlayPID=$!
		echo ${dmdPlayPID} > ${dmdPlayPIDFile}
		debug "Launched clock.  Launched via dmd-play in background with command: ${dmdPlayHD} ${dmdPlayCmd}, storing PID: ${dmdPlayPID} in ${dmdPlayPIDFile}.  dmd-play exit code: ${dmdResult}"

	elif [[ $1 == "|clear|" ]]
	then
		dmd-play ${dmdPlayCmd}
		dmdResult=$?
		debug "Cleared Marquee. Cleared via dmd-play with command: ${dmdPlayCmd}.  dmd-play exit code: ${dmdResult}"

		# Sometimes the first call doesn't work - send it again
		#dmd-play -f /userdata/system/dmd/black.png
		
	else
		dmd-play ${dmdPlayHD} -t ${dmdPlayCmd}
		dmdResult=$?
		debug "Marquee is text. Played via dmd-play with command: ${dmdPlayHD} -t ${dmdPlayCmd}.  dmd-play exit code: ${dmdResult}"
	fi
fi
