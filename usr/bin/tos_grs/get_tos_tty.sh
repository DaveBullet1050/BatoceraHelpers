#!/bin/bash
#
# Get the tty the TOS GRS controller is on
tos_tty=`grep -l -m1 PRODUCT=2341/8036/100 /sys/class/tty/tty*/device/uevent | cut -f 5 -d"/"`

if ! [ -z $tos_tty ]
then
	echo "/dev/$tos_tty"
fi
