from machine import Pin, PWM
import utime

# defines
SERVO_NEUTRAL = 1500000
SERVO_MIN = 450000
SERVO_MAX = 2550000

# pins
led = Pin(25, Pin.OUT)
pwm = PWM(Pin(15))

# setup pwm for servo
pwm.freq(50)
pwm.duty_ns(SERVO_NEUTRAL)

while True:
    led.toggle()
    pwm.duty_ns(SERVO_MIN)
    utime.sleep(0.5)
    led.toggle()
    pwm.duty_ns(SERVO_NEUTRAL)
    utime.sleep(0.5)
    led.toggle()
    pwm.duty_ns(SERVO_MAX)
    utime.sleep(0.5)
    led.toggle()
    pwm.duty_ns(SERVO_NEUTRAL)
    utime.sleep(0.5)
