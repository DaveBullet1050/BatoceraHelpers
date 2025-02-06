#!/bin/bash

# ES screensaver-start
#
# Display a clock in a random colour

# Set file locations and PATH
source /usr/bin/dmd-helper/es-set-vars.sh

progname=$(basename "$(readlink -f ${0})"):screensaver-start:

echo >> ${esScriptLogFile}
echo "${progname}STARTED.  Playing clock" >> ${esScriptLogFile}

# rand=$(( ( RANDOM % 9 )  + 1 ))

# case ${rand} in
	# 1)
		# colour='blue'
	# ;;
	# 2)
		# colour='red'
	# ;;
	# 3)
		# colour='green'
	# ;;
	# 4)
		# colour='magenta'
	# ;;
	# 5)
		# colour='white'
	# ;;
	# 6)
		# colour='orange'
	# ;;
	# 7)
		# colour='yellow'
	# ;;
	# 8)
		# colour='cyan'
	# ;;
	# 9)
		# colour='purple'
	# ;;
# esac

#echo "${progname}Colour is: ${colour}" >> ${esScriptLogFile}

source es-dmd-play.sh '|clock|'

exit 0