# GPIO based shutdown / startup for Pi 3B+

## /boot/config.txt changes
Add  
`dtoverlay=gpio-shutdown,gpio_pin=3,active_low=1,gpio_pull=up`  
The above does NOT do a power off.  Reason being, you may want to power cycle for some reason and a poweroff prevents the button from turning it back on.  If you want to power off then change to:  
`dtoverlay=gpio-poweroff,gpio_pin=3,active_low=1,gpio_pull=up`  

Note: the above assumes your button is connected between physical pins 5 and 6 as per: https://pinout.xyz/  Physical pin 5 is mapped to logical "GPIO 3".  There is no need to put an inline resistor or other component in.  i.e. a basic momentary push button that connects (shorts) pin 5 (GPIO 3) and pin 6 (Ground) is all you need.  

## batocera.conf change to support a momentary push button
Update your batocera.conf to include:  
`system.power.switch=PIN56PUSH`  
The above is for a momentary push button. Push and release to shutdown, push and release to start back up.

## triggerhappy scripts to "listen" to the button
Add these lines:
```
KEY_POWER       1               batocera-shutdown 1
KEY_POWER       0               batocera-shutdown 0
```
to:  
`/userdata/system/configs/multimedia_keys.conf`  

With all of the above done, the KEY_POWER event is enabled and will be triggered when the GPIO pin 3 (physical pin 5) is shorted to ground via the button.  Pressing again, will boot the pi back up again.
