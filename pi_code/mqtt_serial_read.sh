#!/bin/bash
#***********************************************
# This script translates serial data messages into MQTT
# messages for communication with the PICO.
#
# The relevant MQTT topics:
#   - /alarm/plant   		(PI <-- PICO)
#   - /alarm/pump			(PI <-- PICO)
#   - /sensor/light  		(PI <-- PICO)
#	- /sensor/moisture  	(PI <-- PICO)
#***********************************************
instance=$1
IFS=','
while read -ra line
do
	if [ ! -z ${line[0]} ]
	then
		mosquitto_pub -m "${line[0]}" -t "plant/"$instance"/alarm/plant"
		mosquitto_pub -m "${line[1]}" -t "plant/"$instance"/alarm/pump"
		mosquitto_pub -m "${line[2]}" -t "plant/"$instance"/sensor/moisture"
		mosquitto_pub -m "${line[3]}" -t "plant/"$instance"/sensor/light"


	fi
	
done < /dev/ttyACM0

