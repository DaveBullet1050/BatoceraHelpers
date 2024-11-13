#!/bin/bash

# Introduction and links
# ----------------------
# This script drives a TOS GRS switchable restrictor gate for Sanwa joysticks.
#
# The kit is available here.  First link is a full kit to do one joystick
# https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-all-in-one-kit
# Then purchase one of these kits for each additional joystick
# https://thunderstickstudio.com/products/tos-grs-4-to-8-way-restrictor-extension-kit
#
# Software needed
# ---------------
# Put the following3 files  in the same folder (and ensure you make them executable with a chmod 755 *)
# Default location: /usr/bin/tos_grs
#
# tos428cl.exe - downloaded from the thunderstickstudio site (see links above)
# ld-linux-armhf.so.3 - obtained from an Armv7 / 32-bit Raspberry Pi distribution (or in the same git folder as this script)
# libc.so.6 - obtained from an Armv7 / 32-bit Raspberry Pi distribution (or in the same git folder as this script)
#
# Put the roms4wayWithPath.txt
# in a configuration folder named: /userdata/system/configs/tos_grs
#
# NB: The thunderstick version of roms4way.txt needs to have each line prefixed with "mame/" for this script to work
# (as this script is multi-emulator aware).  Therefore a custom roms4WayWithPath.txt was created
#
# How the script works and configuration
# --------------------------------------
# If the rom being played is found in the 4 way roms4WayWithPath.txt position file (e.g. mame/puckmap.zip)
# then switch to 4 way mode, otherwise (if rom not in file) switch to 8 way.
#
# To "remember or change" what a game should be, simply use your TORS GRS button to change modes
# for the game you are currently playing, and on exit, the setting will be stored (via the gameStop function below).
#
# To configure the script - set the 3 variables in the CONFIGURATION section below.  They are
# 1. Path to TORS GRS exe (to get / set controller direction)
# 2. Path to file containing roms that should be in 4 way mode (roms4WayWithPath.txt)
# And optionally:
# 3. Log file location (if you want to debug things) - default is /dev/null
# All paths are absolute (fully qualified)

# roms4wayWithPath.txt file format
# --------------------------------
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

# Set the following to your desired locations and where the EXE and ROMS 4 way file are located

# Change these depending on where you've located the tos428cl_exe (and 32 bit library files) and roms4way.txt
tos428exe=/usr/bin/tos_grs/tos428cl.exe
roms4wayFile=/userdata/system/configs/tos_grs/roms4wayWithPath.txt

# Deubgging (optional). Uncomment /tmp/game_start_stop.log and comment the /dev/null line
# if you want to debug
logfile='/dev/null'
#logfile='/tmp/game_start_stop.log'

# CONFIGURATION ENDS.

echo >> ${logfile}
echo LAUNCHED: `date +%x' '%X` >> ${logfile}

echo Command line from Batocera: "$@" >> ${logfile}
progname=`basename ${0}`
scriptPath=`dirname -- ${0}`
exePath=`dirname ${tos428exe}`
tosExe="${exePath}/ld-linux-armhf.so.3 --library-path ${exePath} ${tos428exe}"
echo \$tosExe: ${tosExe} >> ${logfile}
port=`${tosExe} getport`

# This is the romname prefixed by the directory it is in
romName=`basename \`dirname "${5}"\``/`basename "${5}"`
echo \$romName: $romName >> ${logfile}

# Check if the ROM is in the 4 way file = 1 (yes)
is4wayGame=`grep -c -F "${romName}" $roms4wayFile`
echo \$is4wayGame: $is4wayGame >> ${logfile}

# Case selection for first parameter parsed, our event.
case $1 in
    gameStart)
		echo Game is starting >> ${logfile}
		if [ $is4wayGame = 1 ]
		then
			echo "$romName is 4 way.  Setting controller" >> ${logfile}
			${tosExe} ${port} setway,all,4 >> ${logfile} 2>&1
		else
			echo "$romName is 8 way.  Setting controller" >> ${logfile}
			${tosExe} ${port} setway,all,8 >> ${logfile} 2>&1
		fi
    ;;
	gameStop)
		echo Game is stopping >> ${logfile}
		# Get the controller position. As both controllers are pivoted together
		# we only need to sample the first controller
		currentWay=`${tosExe} ${port} getway,1`
		echo \$currentWay: $currentWay >> ${logfile} 2>&1
		
		# Combinations:
		# If the current position is 4 way and rom IS in the 4 way file, do nothing
		# If the current position is 4 way and rom is NOT in the 4 way file, ADD IT
		# If the current position is 8 way and rom is NOT in the 4 way file, do nothing
		# If the current position is 8 way and rom IS in the 4 way file, REMOVE IT
		
		if [ $currentWay = 4 ]
		then
			if [ $is4wayGame = 1 ]
			then
				echo Current setting: 4 way and already in file, do nothing >> ${logfile} 2>&1
				break
			else
				echo Current setting: 4 way and NOT in file, add it >> ${logfile} 2>&1
				echo $romName >> $roms4wayFile
			fi
		else
			# Current position is 8 way
			if [ $is4wayGame = 0 ]
			then
				echo Current setting: 8 way and NOT in file, do nothing >> ${logfile} 2>&1
				break
			else
				echo Current setting: 8 way and IN file, remove it >> ${logfile} 2>&1
				grep -v $romName $roms4wayFile > $roms4wayFile.b
				mv $roms4wayFile.b $roms4wayFile
			fi
		fi
	;;
esac
