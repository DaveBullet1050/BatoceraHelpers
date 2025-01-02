#!/bin/bash

# Toggles retroarch pause emulator

# Debugging (optional). Uncomment /tmp/game_start_stop.log and comment the /dev/null line
# if you want to debug
logfile='/dev/null'
#logfile='/tmp/load_disk.log'

progname=`basename ${0}`
echo LAUNCHED: ${progname} on `date +%x' '%X` >> ${logfile}
echo Command line: "$@" >> ${logfile}

echo Toggling pause. >> ${logfile}
echo -n "PAUSE_TOGGLE" | nc -c -u -w1 127.0.0.1 55355 >> ${logfile}

exit 0
