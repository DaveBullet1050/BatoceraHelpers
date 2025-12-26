# Coin acceptor / slot

A coin acceptor emits a pulse, usually +5v when a suitable coin is inserted.  I've chosen to use an octocoupler relay to "capture" this pulse and then close the contacts of the relay across the button that's normally used for getting credits in emulators like MAME.  I've made this a little more complex that I needed to in two ways:
1. I wanted the coin button to be disabled when the coin acceptor is "turned on" for the player.  This means you are forced to get credits by inserting coins and not cheating by using the button
2. I wanted to decouple the earths / voltages of the coin acceptor, should it short or do something peculiar and therefore not blow up my zero delay encoders.  The octocoupler relay achieves this and also removes the need to worry about a common signal ground (as without this, you'll get random pulses/credits appearing in your games!)  

Refer to the circuit diagram below:
![Coin acceptor circuit diagram](../image/Coin%20acceptor%20circuit%20diagram.png)

Everything prefixed with "P1" is duplicated for Player 2 (i.e. the power supply and coin slot are the same).  This allows a single coin acceptor mechanism to be used for 2 players, with each one separately enabled or disabled via their own toggle switch.

Normally the white wire is meant to be connected to the relay (IN2) and not the grey (counter) wire.  I couldn't get a reliable pulse on my acceptor, but the counter (grey) wire seemed to emit a suitable voltage to trigger the relay (> 1.4v) every time a coin was inserted, so went with that.   

The way it works...
1. When power is supplied to your arcade machine, the 12vDC power goes on and turns on the coin acceptor
2. When either player turns their toggle switch on, this supplies power to their octocoupler relay and also the 12v relay to complete the negative circuit to activate the octocoupler for that player.  The octocoupler relay supplies power to IN1 which causes NC1 connection to go open and this disables the coin button from working
3. When a coin is inserted into the acceptor, a pulse is emitted on IN2 which completes the circuit between COM2 and NO2 simulating a button push on the coin button  

All parts were sourced from AliExpress.  Links at time of writing are below:  
[12v Octocoupler relay - buy 2 x 2 channel or 1 x 4 channel](https://www.aliexpress.com/item/1005003115242777.html?spm=a2g0o.productlist.main.5.6eabt50Vt50VxZ&algo_pvid=dd5beeb1-421b-4c63-9249-e2de906eb394&algo_exp_id=dd5beeb1-421b-4c63-9249-e2de906eb394-2&pdp_npi=4%40dis%21NZD%213.87%213.87%21%21%212.13%212.13%21%402101e9a217355236919568991e5f73%2112000024182786322%21sea%21NZ%21122820545%21X&curPageLogUid=6ddbfeXLncSC&utparam-url=scene%3Asearch%7Cquery_from%3A)  
[Toggle switch with LED backlight](https://www.aliexpress.com/item/32814414923.html?spm=a2g0o.productlist.main.3.69901b3764ez3Z&algo_pvid=fb907c37-1f58-40f6-ad25-6c075c5c95ef&algo_exp_id=fb907c37-1f58-40f6-ad25-6c075c5c95ef-1&pdp_npi=4%40dis%21NZD%212.89%212.89%21%21%211.59%211.59%21%402103277f17355238135144180e49b3%2164734284584%21sea%21NZ%21122820545%21X&curPageLogUid=tLwVwM3lHhdS&utparam-url=scene%3Asearch%7Cquery_from%3A)  
[Coin Acceptor - 926 model, has an alloy faceplate](https://www.aliexpress.com/item/1005004200444389.html?spm=a2g0o.productlist.main.1.341c4467fCja3Z&algo_pvid=09f349dc-2a50-4bbf-a8a9-88cfbe1c3497&algo_exp_id=09f349dc-2a50-4bbf-a8a9-88cfbe1c3497-0&pdp_npi=4%40dis%21NZD%2153.03%2153.03%21%21%2129.22%2129.22%21%40210318e817355238562922771e6c7b%2112000028358860456%21sea%21NZ%21122820545%21X&curPageLogUid=zYEhJbyOZq8n&utparam-url=scene%3Asearch%7Cquery_from%3A)  
[USB zero delay encoder](https://www.aliexpress.com/item/1005007864535321.html?spm=a2g0o.productlist.main.13.3ab84c8cCxk797&algo_pvid=938f849f-19ea-46b6-aa73-233cf19e21d1&algo_exp_id=938f849f-19ea-46b6-aa73-233cf19e21d1-6&pdp_npi=4%40dis%21NZD%2111.75%216.13%21%21%2147.32%2124.71%21%402103277f17355240160963766e49b4%2112000042739682455%21sea%21NZ%21122820545%21X&curPageLogUid=tDm0b6UBd21K&utparam-url=scene%3Asearch%7Cquery_from%3A)  

If you need to program your acceptor, these instructions may help:
<img width="800" height="540" alt="image" src="https://github.com/user-attachments/assets/dd8e2d52-b5f9-436a-b138-c90f66f6df71" />
