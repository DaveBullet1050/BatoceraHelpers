# Streaming from / remote control of your Batocera machine

There's an open source project called [Sunshine](https://github.com/LizardByte/Sunshine) that runs as a server, allowing remote display of the Batocera desktop (ES/gaming emulator) from a client running Moonlight.  Both Sunshine and Moonlight are multiplatform.  

## Simplest installation on Batocera
Deploy this [service](https://github.com/n2qz/batocera-service-sunshine/tree/master) and start it.  You can then connect from a client running Moonlight.  This service will automatically download the sunshine server for you.  Start the service by going into the main batocera (ES) menu by pressing `START -> SYSTEM SETTINGS -> SERVICES` and toggle on SUNSHINE.

## Alternative installation
If you want to control which version is downloaded, follow these steps:
1. Choose the appropriate binary from the assets under the [latest release](https://github.com/LizardByte/Sunshine/releases).  For Batocera on x86/64, download `sunshine.Appimage` (binary).
2. Move the sunshine.Appimage to `/usr/bin/sunshine` (i.e. rename it)
3. Run `chmod 755 /usr/bin/sunshine`
4. Run `batocera-save-overlay 100` (the 100 is to allow for enough space in the overlay file to store the binary) 
5. Download the [/userdata/system/services/sunshine](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/userdata/system/services/sunshine) service
6. Run `chmod 755 /userdata/system/services/sunshine`
7. Finally - go into the main batocera (ES) menu by pressing `START -> SYSTEM SETTINGS -> SERVICES and toggle on SUNSHINE` to start the service  

If the service started succesfully, you should be able to connect to it from a PC/client via browsing to `batocera.local:47990`.  

## Initial connection
Sunshine expects a pin to be generated and entered on the Moonlight client.  When you open up Moonlight, it should auto-discover the sunshine server.  When you connect from moonlight, moonlight will prompt you for a pin number.  Go to the Sunshine configuration URL (above) and select **PIN** from the menu, then enter a pin number (e.g. 1234) and the hostname of the moonlight client that is connecting.  You can then enter that pin on the moonlight client.  The connection should succeed and pin remembered for next time.

## Moonlight client
You need a moonlight client to connect and effectively "remote desktop / stream" your Batocera machine.  The http service above is purely for configuration.  Download the appropriate Moonlight client.  Here's a [link to the PC version](https://github.com/moonlight-stream/moonlight-qt/releases).  

## Keyboard only play
If the PC you are going to use it from has no gamepads and only a keyboard and you want to send all keyboard commands to the sunshine server (e.g. Alt-F4 to close the game/emulator on Batocera), browse to the configuration URL: `batocera.local:47990` and change settings as shown:  
<img width="1567" height="514" alt="image" src="https://github.com/user-attachments/assets/149385e2-f8ab-4c15-b18d-a56e7e9c884f" />

On your Moonlight client, go into settings and ensure **Capture system keyboard shortcuts** is set to **in fullscreen** as shown:  
<img width="1011" height="412" alt="image" src="https://github.com/user-attachments/assets/f3963bfd-9d7b-40e4-9809-5e818be045f0" />

The above will prevent sunshine/moonlight from assuming your moonlight client has gamepads attached.

## Moonlight - closing connection
Press `CtrlAlt-Shift-Q`  
