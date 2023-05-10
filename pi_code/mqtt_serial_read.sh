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

# Topic registration
base_topic=$1
dev=$2

if [ "$base_topic" = "help" ]
then
	echo "mqtt_serial_read [plant id] [device location]"
	exit 0
fi

if [ -z "$base_topic" ]
then 
    echo "Error:Base topic needs to be defined" 
    exit 64
fi 

if [ -z "$dev" ]
then
    echo "Error: An I/O device needs to be specified!"
    exit 32
fi

IFS=','
while read -ra line
do
	if [ ! -z ${line[0]} ]
	then
		mosquitto_pub -m "${line[0]}" -t "plant/$base_topic/alarm/plant"
		mosquitto_pub -m "${line[1]}" -t "plant/$base_topic/alarm/pump"
		mosquitto_pub -m "${line[2]}" -t "plant/$base_topic/sensor/moisture"
		mosquitto_pub -m "${line[3]}" -t "plant/$base_topic/sensor/light"


	fi
	
done < $dev

