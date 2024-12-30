# Coin acceptor slot

A coin acceptor emits a pulse, usually +5v when a suitable coin is inserted.  I've chosen to use an octocoupler relay to "capture" this pulse and then close the contacts of the relay across the button that's normally used for getting credits in emulators like MAME.  I've made this a little more complex that I needed to in two ways:
1. I wanted the coin button to be disabled when the coin acceptor is "turned on" for the player.  This means you are forced to get credits by inserting coins and not cheating by using the button
2. I wanted to decouple the earths / voltages of the coin acceptor, should it short or do something peculiar and therefore not blow up my zero delay encoders.  The octocoupler relay achieves this and also removes the need to worry about a common signal ground (as without this, you'll get random pulses/credits appearing in your games!) 

Refer to the circuit diagram below:
![Coin acceptor circuit diagram]([http://url/to/img.png](https://github.com/DaveBullet1050/BatoceraHelpers/blob/main/image/Coin%20acceptor%20circuit%20diagram.png?raw=true))
