#!/bin/bash
temp_1000=$(cat /sys/class/thermal/thermal_zone*/temp)
temp=$(($temp_1000 / 1000))
echo "CPU temperature: $temp C"
