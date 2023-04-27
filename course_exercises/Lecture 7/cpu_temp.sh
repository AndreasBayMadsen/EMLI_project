#!/bin/bash
temp_1000=$(cat /sys/class/thermal/thermal_zone*/temp)
temp=$(($temp_1000 / 1000))

mosquitto_pub -h localhost -u mosqui -P tto -t mosqui/cpu_temp -m $temp
