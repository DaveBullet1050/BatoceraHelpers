import sys
import os

# Define the path to your custom package directory
# Use an absolute path for reliability
custom_path = "/userdata/system/python-packages" 

# Append the path to the system path
sys.path.append(custom_path)

from pynput.keyboard import Key, Controller
    
def press_key(first_key, second_key):
    # Create a keyboard controller instance
    keyboard = Controller()    

    try:
        #print(f"first_key: {first_key}")
        # Check if it's a special key (f1, esc, enter)
        if hasattr(Key, first_key.lower()):
            t1 = getattr(Key, first_key.lower())
        else:
            # Otherwise, treat it as a normal character ('a', '1', etc.)
            t1 = first_key

        if second_key is not None:
            #print(f"second_key: {second_key}")
            if hasattr(Key, second_key.lower()):
                t2 = getattr(Key, second_key.lower())
            else:
                # Otherwise, treat it as a normal character ('a', '1', etc.)
                t2 = second_key

            with keyboard.pressed(t1, t2):
                keyboard.press(t2)
                keyboard.release(t2)
            pressed = first_key + "+" + second_key
        else:
            keyboard.press(t1)
            keyboard.release(t1)
            pressed = first_key

        print(f"Triggered: {pressed}")

    except AttributeError as e:
        print(f"Error: {e} is not a valid key in pynput.keyboard.Key")

    except Exception as e:
        print(f"Failed to press: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        second_key = sys.argv[2] if len(sys.argv) > 2 else None
        press_key(sys.argv[1], second_key)
    else:
        print(f"Usage: python {sys.argv[0]} <key_name>")
        print(f"Example: python {sys.argv[0]} f1")