#!/bin/bash

source /usr/bin/dmd-helper/es-set-vars.sh

progname=$(basename "$(readlink -f ${0})"):screensaver-stop:

echo >> ${esScriptLogFile}
echo "${progname}STARTED" >> ${esScriptLogFile}

# Get dmd-toggle to check if we should restore the last marquee or simply clear the screen (DMD may be set to off)
source dmd-toggle.sh
