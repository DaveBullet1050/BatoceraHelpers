#!/bin/bash
#
# This script is sourced within several other scripts used to manage DMD marquee changes
# The scripts that source are located in esScriptDir and /usr/bin (dmd-*.sh) locations

# Settings from batocera.conf
# If dmd-play is configured as a service then send changes to system or game marquees via TCP
# Otherwise dmd-play will be launched on every system (or game) marquee change
# Will default to interactive if the service is not running for any reason

# Used as a prefix for debug entries.
# ES launches /var/run/emulationstation/scripts/system-selected/dmd-server.sh which is a sym link to
# /usr/share/dmd-simulator/scripts/system-selected.sh.  readlink allows us to resolve the symlink
# and return "system-selected.sh" as the progname (instead of the generic dmd-server.sh). Only used
# for logging (so we can distinguish between game started and system selected events
progname=$(basename "$(readlink -f ${0})"):$BASHPID:

[[ -n ${varsSet} ]] && return

# Use TCP to send dmd-play (marquee) changes, instead of per game/system change
#dmdPlayMode=`batocera-settings-get system.services`
#[[ ${dmdPlayMode} == *dmd_play* ]] && playAsService=x
dmdPlayService=`ps -ef | awk "/dmd-play -lp/" | wc -l`
# AWK above will count itself.  Result = 2 if dmd-play is running as a service
[[ ${dmdPlayService} -eq 2 ]] && playAsService=set

# Listener port when dmd-play running as a service
playPort=`batocera-settings-get dmd.play.port`
! [[ ${playPort} =~ ^[0-9]+$ ]] && playPort=6788

# Whether the game marquee changes on selection of game in the list or only when launched
dmdChangeGameMarquee=`batocera-settings-get dmd.change.select`
[[ ${dmdChangeGameMarquee} == "yes" ]] && changeOnSelect=set

# Only relevant if dmd.change.gamemarquee=selected.  How long the user must settle on a selected system or game for the marquee to change (avoids rapid fire changes when user scrolling through games / systems quickly)
changeWaitTime=`batocera-settings-get dmd.change.waittime`
! [[ ${changeWaitTime} =~ ^[+]?[0-9]+\.?[0-9]*$ ]] && changeWaitTime=0.33

# Displays the clock on the marquee when batocera goes into screensaver mode, otherwise default behaviour (batocera splash or custom marquee image)
dmdScreenSaver=`batocera-settings-get dmd.screensaver.clock`
[[ ${dmdScreenSaver} == "yes" ]] && clockScreenSaver=set

# If set, then GIF marquee files will be played on repeat, otherwise only once
dmdScreenSaver=`batocera-settings-get dmd.play.repeat`
[[ ${dmdScreenSaver} == "yes" ]] && playRepeat=set

lastEventFile='/tmp/es_last_event'
previousEventFile='/tmp/es_previous_event'
selectedScriptPidFile='/tmp/es_selected_pid'
lastMarqueeFile='/tmp/es_last_marquee'
dmdPlayPIDFile='/tmp/dmd_play.pid'
dmdPlayServicePIDFile='/var/run/dmd_play_service.pid'
# Location of scripts that ES triggers on events.  This usually doesn't need to change unless you relocate them in ES config
esScriptDir='/userdata/system/configs/emulationstation/scripts'

# Debug log.  Set to path of log file.  Uncomment to debug or comment for no debugging (faster!)
#esScriptLogFile='/tmp/es_script.log'

# Common function used in all scripts to write debug info
debug() {
	if [[ -n ${esScriptLogFile} ]]; then echo "${progname}${@}" >> ${esScriptLogFile}; fi
}

varsSet=1
debug "Vars set: playAsService:${playAsService} playPort:${playPort} changeOnSelect:${changeOnSelect} changeWaitTime:${changeWaitTime} clockScreenSaver:${clockScreenSaver} playRepeat:${playRepeat}"