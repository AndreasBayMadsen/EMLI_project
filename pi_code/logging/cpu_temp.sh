#!/bin/bash
#***********************************************
# This script returns the CPU temperature
#***********************************************

# Read data from '/sys/class/thermal/thermal_zone0/temp'
data=$(cat /sys/class/thermal/thermal_zone0/temp)
temp=$(bc <<< "scale=2; $data/1000")

# Return result
echo $temp