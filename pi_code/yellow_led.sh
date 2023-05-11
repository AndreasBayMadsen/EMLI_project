#!/bin/bash

#............................................
#Yellow Led : Lights up if moisture alarm is active

#sends to yellow led topic 


#...........................................

base_topic=$1

# check if base topic is created
if [ -z "$base_topic" ]
then 
        echo "Error: Base topic needs to be defined" 
        exit 64
fi 


while :
do 
	message=$(mosquitto_sub -t plant/$base_topic/alarm/moisture -C 1 -W 3)

	if [ -z $message ] || [ $message -eq 1 ]
	then 
		message="on"

	fi

	# send to yellow LED

	if [ $message = "on" ]
	then 
		mosquitto_pub -t plant/$base_topic/remote/led/yellow -m  "on"
			echo " Moisture below Threshold"
	else 
		mosquitto_pub -t plant/$base_topic/remote/led/yellow -m  "off"
		echo " moisture ok "
	fi

done 
