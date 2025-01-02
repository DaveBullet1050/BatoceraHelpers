from evdev import list_devices, UInput, InputDevice, ecodes as e

devices = [InputDevice(path) for path in list_devices()]
for device in devices:
    if 'Keyboard' in device.name:
        kb = device.path
        break
        
ui = UInput.from_device(kb, name='keyboard-device')
ui.write(e.EV_KEY, e.KEY_F1, 1)
ui.syn()
