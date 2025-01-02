#!/bin/bash

# This script switches to the disk index requested for libretro cores that support disk management and games
# that require it.  It stores the currently selected disk # in /tmp/current_disk.txt and will use that to
# go previous/next depending on which index is requested.  It doesn't know the names of disks, just position
#
# Usage:
# load_disk.sh <disk_number>
#
# eg:
# load_disk.sh 3

# Deubgging (optional). Uncomment /tmp/game_start_stop.log and comment the /dev/null line
# if you want to debug
#logfile='/dev/null'
logfile='/tmp/load_disk.log'

progname=`basename ${0}`
echo LAUNCHED: ${progname} on `date +%x' '%X` >> ${logfile}
echo Command line: "$@" >> ${logfile}

# Check only numbers are provided, error if not
number_regex='^[0-9]+$'
if ! [[ "$1" =~ $number_regex ]]
then
	echo "$1 not a number, aborting" >> ${logfile}
	exit 1
fi

# Check which disk number has been requested.  If no index file (used to store the last disk selected) exists
# then assume we are at disk 1
if ! [ -f /tmp/curr_disk.txt ]
then
	echo 1 > /tmp/curr_disk.txt
fi

curr_disk=`cat /tmp/curr_disk.txt`

echo Requested disk: "$1", current disk "$curr_disk" >> ${logfile}

if [ "$1" -eq "$curr_disk" ]
then
	echo Requested and current disk the same, nothing to do. Exiting. >> ${logfile}
	exit 0
fi

# Different disk requested than currently loaded. First, eject the current disk, so we can skip forward
echo Ejecting disk. >> ${logfile}
echo -n "DISK_EJECT_TOGGLE" | nc -c -u -w1 127.0.0.1 55355 >> ${logfile}
sleep 0.5

# Loop depends on whether we need to go forward or backward
if [ "$1" -gt "$curr_disk" ]
then
	echo Need to skip forward >> ${logfile}
	# Need to skip forward
	while [ "$curr_disk" -lt "$1" ]
	do
		echo Sending command >> ${logfile}
		echo -n "DISK_NEXT" | nc -c -u -w1 127.0.0.1 55355 >> ${logfile}
		sleep 0.5
		curr_disk=$(($curr_disk + 1))
		echo Current disk now: "$curr_disk" >> ${logfile}
	done
else
	# Need to go backwards
	echo Need to skip backward >> ${logfile}
	# Need to skip forward
	while [ "$curr_disk" -gt "$1" ]
	do
		echo Sending command >> ${logfile}
		echo -n "DISK_PREV" | nc -c -u -w1 127.0.0.1 55355 >> ${logfile}
		sleep 0.5
		curr_disk=$(($curr_disk - 1))
		echo Current disk now: "$curr_disk" >> ${logfile}
	done
fi

# Close the disk drive
echo Closing disk. >> ${logfile}
echo -n "DISK_EJECT_TOGGLE" | nc -c -u -w1 127.0.0.1 55355

# And press F1 to continue (if Ultima IV)
romName=`cat /tmp/curr_game.log`
if [[ $romName == c64/Ultima* ]]
then
	echo Game is Ultima so sending F1 key >> ${logfile}
	python /usr/bin/press_key_f1.py
fi

# Lastly, store the current disk state for next time
echo $curr_disk > /tmp/curr_disk.txt
 
exit 0
