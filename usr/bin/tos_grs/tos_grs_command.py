import serial
import sys

try:
    # Open the TOS GRS port provided - e.g. /dev/ttyACM0.  add a timeout incase there are any issues (so it doesn't hang).  < 1 second doesn't allow enough time to get an "ok" if controller has to change joystick directions, allowing time for servos to respond
    tty = serial.Serial(sys.argv[1], baudrate=115200, timeout=1, write_timeout=1)
    # Send the command -e.g. "setway,all,8" as a set of bytes
    byteCommand = sys.argv[2].encode()
    tty.write(byteCommand)
    # Read the response as a string, stripping newline characters
    rc = tty.readline().decode().replace("\r\n", "")
    tty.close()
    # Output the response so it can be captured shell script side in a variable
    print(rc) 

except:
    # Discard errors, just discard low level python error and return a non-success status. Not helpful, but hey
    sys.exit(1)

sys.exit(0)