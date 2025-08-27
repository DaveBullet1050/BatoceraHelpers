#!/bin/bash

# Checks whether the global, system or game settings are set for a CRT aka "curvature" shaderset
# If so, swaps in the 2 files that allow you to toggle / cycle between relevant shaders for flipping
# the screen in retroarch for single player (mainly mame games) in cocktail mode to use the 2nd players
# controls

sourceDir='/userdata/system/configs/shader_swap'
targetDir='/usr/share/batocera/shaders'

# Batocera tells us the event, we're only interested in games starting or stopping.
case $1 in
    gameStart)
		romName=`basename ${5}`
		# Get the setting at a global, system or game level
		cmd="batocera-settings-get $2"'["'"$romName"'"]'".shaderset $2.shaderset global.shaderset"
		echo $cmd
		shaderset=$($cmd)
		echo $shaderset
		if [ $shaderset == "curvature" ]
		then
			cp $sourceDir/stock_crt.glslp $targetDir/rightside_up.glslp
			cp $sourceDir/upside_down_crt.glslp $targetDir/upside_down.glslp
		else
			cp $sourceDir/stock.glslp $targetDir/rightside_up.glslp
			cp $sourceDir/upside_down.glslp $targetDir/upside_down.glslp
		fi		
    ;;
	gameStop)
	;;
esac

exit 0
