#!/bin/bash

#....................................................
# mqtt sript to generate moisture alarm if moisture level to low
# alarm will be send to yellow LED script 
#...................................................

base_topic=$1

## check if base topic is created
if [ -z "$base_topic" ]
then 
        echo "Error:Base topic needs to be defined" 
        exit 64
fi 

# set Level for critical moisture 
CRITICAL_MOISTNESS=40


while :
do

# read MQTT Topics
MoistureLevel=$(mosquitto_sub  -t plant/$base_topic/sensor/moisture -C 1 -W 3 ) 
echo "$MoistureLevel"

# -- if connection fails give alarm 
if [ -z $MoistureLevel ]
then  
        MoistureLevel=0
fi

# check 

if [ $MoistureLevel -lt $CRITICAL_MOISTNESS  ]  # || [ -z $MoistureLevel ]

then
        mosquitto_pub -t plant/$base_topic/alarm/moisture -m  1
        echo " Moisture alarm! Red Maden!"
else 
	mosquitto_pub -t plant/$base_topic/alarm/moisture -m  0

fi



done
