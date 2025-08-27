# Using Retroarch shaders for a side by side cabinet screen flip for MAME games

Early MAME games (e.g. Puckman) only supported a single joystick / set of controls for both players.  To get player 2 controls to work, you configure the game to be "Cocktail" cabinet mode.  To do this, go into MAME settings (do this by running up the MAME game to reconfigure and pressing your MAME menu button - the START button in my system) then go Dip Switches -> Cabinet and toggle to "Cocktail".  This will persist.

The problem is my cabinet separate controls for each player (side by side), meaning both players are looking at the screen in the same orientation.  So - when games like Puckman go into cocktail mode to activate the opposite player 2 controls, the screen flips upside down.

To work around this, I make use of Retroarch shaders, which allow fine grained control over display.  For example, if you want a CRT curvature effect with scanlines, then shaders will provide this on an LCD monitor.  By pressing a button (or hotkey + button) you can cycle between shaders when players die to flip / unflip the screen.  It's not automated, but at least allows you to stay seated and use your own controls.

I ended up using a custom shader: [upside_down.glslp](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/usr/share/batocera/shaders/upside_down.glslp) which flips the screen in the X/Y axis.  To activate, I have a hotkey setup (Select + P1 Start button) in [batocera.conf](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/batocera.conf):  
```
global.retroarch.input_shader_prev_btn=7
global.retroarch.input_shader_next_btn=7
global.retroarch.input_shader_toggle_btn=nul
```
When pressing Select - P1 Start, retroarch sequences from the stock shader (right side up) to the custom upside down shader.  It does require a manual press every time player 1 / 2 dies, as MAME ROMS were never designed to run under emulators, therefore have no events that can be hooked for automatic changing of the shader.  

The other small hit is frame skipping on a Pi3B+.  The shader adds some compute and I don't think the Pi3B+ has enough grunt to maintain the frame rate, so you are aware of play not being as smooth. I've since moved to an x64 box (both i3 6th gen and 12th gen processors) and there is no performance hit with shaders.  

## Stock and CRT flippable shaders

The problem with the above shaders, is they have a stock rendering. I wanted the option if a game (or system or indeed globally) we have "curvature" set for the shaderset (in batocera.conf), then I want to have 2 CRT shaders - one rightside up and one upside down to toggle between.  If the game/system/global setting is anything other than "curvature", then I want the stock shaders to be used (again a rightside up and upside down pair).  

I created a script that would be called by batocera on game start event that would check the setting above, then copy over the source shader pair as appropriate to the folder where retroarch looks for shaders.  Then by pressing my "toggle" button (select + P1 start), I either get stock or curvature shaders with an upside down option.  

To get the upside down CRT (curvature) shader, I ended up customising the GLCore code to include the flip logic.  This was easier than chaining shadersets in Retroarch to do the same thing (and likely more performant).  

To get this to work you need to:  
1. Set your Retroarch to use a curvature shaderset:  
- Globally - START -> GAME SETTINGS  
- System level - START -> GAME SETTINGS -> PER SYSTEM ADVANCED GAME CONFIGURATION -> (choose which system, e.g. MAME)  
- Per game - hold down your launch button on the game in question -> ADVANCED GAME OPTIONS  

Then with either 3 above choose:  
GAME RENDERING AND SHADERS -> SHADER SET and choose CURVATURE  

2. Set the graphics API to us to OpenGL. I couldn't find the global menu item setting in ES for this, so it is system level under:  
- START -> GAME SETTINGS -> PER SYSTEM ADVANCED GAME CONFIGURATION -> (choose which system, e.g. MAME) -> GRAPHICS API -> OPENGL
Alternatively, you could try this in /userdata/system/batocera.conf:  
`global.gfxbackend=gl`  

3. Copy down these files:  
```
/userdata/system/scripts/shader_swap.sh
/userdata/system/configs/shader_swap/*
```

4. Finally, delete:  
`/usr/share/batocera/shaders/*.glsl*`

Assuming you have configured an equivalent shader toggle button above, the above script will swap in the correct shaders into the shaders directory used by Retroarch to toggle between stock or curvature options.    


