#!/bin/bash

# Set up pin
echo "16" > /sys/class/gpio/export
echo "in" > /sys/class/gpio/gpio16/direction

# Read pin state
state=$(cat /sys/class/gpio/gpio16/value)
if [ $state -eq '1' ]
then
	echo "ON"
else
	echo "OFF"
fi

echo "16" > /sys/class/gpio/unexport
