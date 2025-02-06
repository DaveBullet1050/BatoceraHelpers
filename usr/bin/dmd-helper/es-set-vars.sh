#!/bin/bash

# Debug log.  Set to /dev/null to skip logging
esScriptLogFile='/tmp/es_script.log'
#esScriptLogFile=/dev/null

# How long the user must settle on a system selection before we attempt marquee update
waitTime=1

lastEventFile='/tmp/es_last_event'
previousEventFile='/tmp/es_previous_event'
selectedScriptPidFile='/tmp/es_selected_pid'
lastMarqueeFile='/tmp/es_last_marquee'
lastDmdPIDFile='/tmp/dmd_play_pid'
PATH=$PATH:/usr/bin/dmd-helper