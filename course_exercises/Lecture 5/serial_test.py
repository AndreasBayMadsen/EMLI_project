import serial
import time

s = serial.Serial("/dev/ttyACM0", 115200)

while True:
    s.write(b"1\n")
    time.sleep(1)
    s.write(b"2\n")
    time.sleep(1)