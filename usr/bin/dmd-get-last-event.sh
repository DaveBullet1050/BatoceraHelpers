#!/bin/bash

# Retrieves the last game or system selected in ES or initialises variables
# if no file (i.e. first time system has been selected - on boot).
#
# Returns:
# 0 - event is the same as last time even if a different process (i.e. user has gone back and forward and landed on the same game)
# 1 - event is different to last time. Process ID isn't superceeded (i.e this is the latest script executing)
# 2 - event is different to last time.  Process ID has been superceded (ie. this event is old, as process ID stored is greater than current)

if [ -f ${lastEventFile} ]
then
	IFS=:
	scriptSystemEvent=`cat ${lastEventFile}`
	read lastScript lastSystem lastEvent <<< ${scriptSystemEvent}
else
	lastEvent=''
fi	

if [ -f ${selectedScriptPidFile} ]
then
	lastSelectedScriptPid=`cat ${selectedScriptPidFile}`
else
	lastSelectedScriptPid=999999
fi

if [[ ${currEvent} == ${lastEvent} ]]
then
	return 0

else
	if [ ${lastSelectedScriptPid} -le ${BASHPID} ]
	then
		return 1
	else
		return 2
	fi
fi
