# Side by side cabinet screen flip for MAME games

My cabinet has 2 players side by side, meaning both players are looking at the screen in the same orientation, unlike a cocktail cabinet which flips the screen when player 2 has a turn.  This page is for MAME games and uses RetroArch shaders to flip the screen for the 2nd player, so the screen is not upside down, allowing play and use of the 2nd player controls on games that normally only use a single set of controls.

Early MAME games (e.g. Puckman) only supported a single joystick / set of controls.  To get player 2 controls to work, you configure the game to be "Cocktail" cabinet mode.  To do this, go into MAME settings (do this by running up the MAME game to reconfigure and pressing your MAME menu button - the START button in my system) then go Dip Switches -> Cabinet and toggle to "Cocktail".  This will persist.

The problem with the above setting, is when in 2 player mode and player 1 dies, the screen will flip for the 2nd player to take their turn.  In a side by side player cabinet, this isn't helpful!

I ended up using a custom shader: [upside_down.glslp](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/share/batocera/shaders/upside_down.glslp)] which flips the screen in the X/Y axis.  To activate, I have a hotkey setup (Seleft + P1 Start button) in [batocera.conf](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/batocera.conf):  
```
global.retroarch.input_shader_prev_btn=7
global.retroarch.input_shader_next_btn=7
global.retroarch.input_shader_toggle_btn=nul
```
When pressing this - it sequences from the stock shader (right side up) to upside down.  It does require a manual press every time player 1 / 2 dies, as MAME ROMS are pure to the machine (as they should be) and do not emit events to an emulator that can be hooked for automatic changing of the shader.  

The other small hit is frame skipping on a Pi3B+.  The shader adds some compute and I don't think the Pi3B+ has enough grunt to maintain the frame rate, so you are aware of play not being as smooth. This should be better on a gruntier Pi / x64 platform.  
