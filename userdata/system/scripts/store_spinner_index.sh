#!/bin/bash

# Ensure the spinner index is correctly set for retroarch
case $1 in
    gameStart)
		spinner_index=`get-spinner-index`
		# Store in batocera.conf
		batocera-settings-set global.retroarch.input_player1_mouse_index $spinner_index

		# And ensure mame core has mouse enabled
		#batocera-settings-set global.retroarchcore.mame_mouse_enable enabled
    ;;
	gameStop)
	;;
esac

exit 0
