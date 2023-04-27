#!/bin/bash
#***********************************************
# This script translates serial data messages into MQTT
# messages for communication with the PICO.
#
# The relevant MQTT topics:
#   - control/pump    			(PI --> PICO)
#***********************************************
instance=$1
#let lastPump=$(date +%s)-5000
while : 
do
	message=$(mosquitto_sub -t "plant/"$instance"/control/pump" -C 1)
	#let timeFromLastPump=$(date +%s)-$lastPump
	#echo $timeFromLastPump
	if [ $message = 1 ] && [ -e /dev/ttyACM0 ] # && [ $timeFromLastPump -gt 3600 ]
	then
			#lastPump=$(date +%s)
			echo "p" > /dev/ttyACM0
	fi
	echo $message
	sleep 1
done
