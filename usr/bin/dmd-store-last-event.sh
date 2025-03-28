#!/bin/bash

# Stores the event type (game or sysrem) plus full path to game ROM or system name event

#debug "dmd-store-last-event:Storing script: ${1}, system: ${2}, event: ${3}"

echo "${1}":"${2}":"${3}" > ${lastEventFile}

echo $BASHPID > ${selectedScriptPidFile}