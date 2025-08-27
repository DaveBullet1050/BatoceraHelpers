#!/bin/bash

# DEPRECATED.  Replaced by sanwa_change.sh

# Introduction and links
# ----------------------
# This script drives a TOS GRS switchable restrictor gate for Sanwa joysticks.
#
# The kit is available here.  First link is a full kit to do one joystick
# https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-all-in-one-kit
# Then purchase one of these kits for each additional joystick
# https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-extension-kit
#
# This requires python (built into Batocera) to correctly handle serial / tty interaction.  Purely using the shell is unreliable with non-blocking issues.
#
# How the script works and configuration
# --------------------------------------
# If the rom being played is found in the 4 way joystick position file (e.g. mame/puckmap.zip)
# then switch to 4 way mode, otherwise (if rom not in file) switch to 8 way.
#
# To "remember or change" what a game should be, simply use your TORS GRS button to change modes
# for the game you are currently playing, and on exit, the setting will be stored.
#
# To configure the script - set the variables in the CONFIGURATION section below.  They are
# 1. Path to file containing roms that should be in 4 way mode
# 2. Change the location of shell and python scripts (if not in /usr/bin/tos_grs)
# And optionally:
# 3. Log file location (if you want to debug things) - default is /tmp/game_start_stop.log
# All paths are absolute (fully qualified)

# roms4way file format
# --------------------
#
# To avoid collisions across emulators (e.g. a MAME rom with the same name as a C64 rom
# when one should be 4 way and one should be 8 way), we qualify the rom name with the directory
# it is in (without leading slash).
#
# i.e. the roms4way file should be in the format
# <rom_directory>/<rom_filename_incl_extension>
#
# e.g.
# mame/puckman.zip

# CONFIGURATION STARTS.
#
# Set the following to your desired locations and where the ROMS 4 way file are located

# Change these depending on where you've located the tos428cl_exe (and 32 bit library files) and roms4way.txt
roms4wayFile=/userdata/system/configs/tos_grs/roms4wayWithPath.txt
exePath=/usr/bin/tos_grs

# Deubgging (optional). Uncomment /tmp/game_start_stop.log and comment the /dev/null line
# if you want to debug
#logfile='/dev/null'
logfile='/tmp/game_start_stop.log'

# CONFIGURATION ENDS.

echo >> ${logfile}

progname=`basename ${0}`
echo LAUNCHED: ${progname} on `date +%x' '%X` >> ${logfile}

echo Command line from Batocera: "$@" >> ${logfile}
scriptLocation=`dirname -- ${0}`

echo "Trying to find TOS GRS controller port." >> ${logfile}
port=`$exePath/get_tos_tty.sh`

if ! [ -z $port ]
then
	echo \$port: $port >> ${logfile}
else
	echo "TOS GRS controller not connected or port not found.  Exiting" >> ${logfile}
	exit
fi

# Get the ROM name.  This is the romname prefixed by the directory (emulator) it is in
romName=`basename \`dirname "${5}"\``/`basename "${5}"`
echo \$romName: $romName >> ${logfile}

# Check if game is in the 4 way file. = 1 - 4 way game, = 0, 8 way game
is4wayGame=`grep -c -F "${romName}" $roms4wayFile`
echo \$is4wayGame: $is4wayGame >> ${logfile}

# Batocera tells us the event, we're only interested in games starting or stopping.
case $1 in
    gameStart)
		echo Game is starting >> ${logfile}

		# Also store the ROM name as the current game for querying in other scripts
		echo $romName > /tmp/curr_game.log

		if [ $is4wayGame = 1 ]
		then
			setWay=4
		else
			setWay=8
		fi
		echo "$romName is ${setWay} way.  Setting controller" >> ${logfile}
		pyCommand="python ${exePath}/tos_grs_command.py ${port} setway,all,${setWay}"
		echo \$pyCommand: $pyCommand >> ${logfile}
		setWayResult=`${pyCommand}`
		if [[ $setWayResult == "ok" ]]
		then
			echo "Command succeeded." >> ${logfile}
		else
			echo "Error sending command.  Error code: $setWayResult" >> ${logfile}
		fi
    ;;
	gameStop)
		echo Game is stopping.  Checking controller direction >> ${logfile}

		# Get the joystick position. As both joysticks are pivoted together
		# we only need to sample the first joystick.
		pyCommand="python ${exePath}/tos_grs_command.py ${port} getway,1"
		echo \$pyCommand: $pyCommand >> ${logfile}
		currentWay=`${pyCommand}`
		echo \$currentWay: $currentWay >> ${logfile} 2>&1
		
		# Combinations:
		# If the current position is 4 way and rom IS in the 4 way file, do nothing
		# If the current position is 4 way and rom is NOT in the 4 way file, ADD IT
		# If the current position is 8 way and rom is NOT in the 4 way file, do nothing
		# If the current position is 8 way and rom IS in the 4 way file, REMOVE IT
		
		# We use regex to match as read adds carriage return to the variable, so this is a lazy way of matching
		if [[ $currentWay == 4* ]]
		then
			if [ $is4wayGame = 1 ]
			then
				echo Current setting: 4 way and already in file, do nothing >> ${logfile} 2>&1
			else
				echo Current setting: 4 way and NOT in file, add it >> ${logfile} 2>&1
				echo $romName >> $roms4wayFile
			fi
		else
			# Current position is 8 way
			if [ $is4wayGame = 0 ]
			then
				echo Current setting: 8 way and NOT in file, do nothing >> ${logfile} 2>&1
			else
				echo Current setting: 8 way and IN file, remove it >> ${logfile} 2>&1
				grep -v $romName $roms4wayFile > $roms4wayFile.b
				mv $roms4wayFile.b $roms4wayFile
			fi
		fi
		
		# Remove currently playing game now it is stopping
		rm /tmp/curr_game.log > /dev/null 2>&1
	;;
esac