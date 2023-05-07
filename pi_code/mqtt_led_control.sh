#!/bin/bash

# .............................................................
# Control of LEDs from MQTT Topics: ledRed , ledYellow , ledGreen
# send to HTML script
# Red	 >> if water Pump Alarm 
# Yellow >> soil moisture below specific
# Green  >> else Green Led 
# Topic: Plant/X/Sensor/Undertopic
#
# MQTT in  >> MQTT out
# -P pasword -u username -p port -h hostname or IP add -t topic
#_pub publisher _sub subscriber -m message -d debug -C counts 
# MQTT  has a message log  -t topic > massages.log to write  >> to append
# to send value of a variable "$variable"  
#..............................................................	
base_topic=1


# check if base topic is created
if [ -z "$base_topic" ]
then 
	echo "Error:Base topic needs to be defined" 
	exit 66
fi 


# Set Level for Controls change for control inputs
M_level=40


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

PumpAlarm=$(mosquitto_sub  -t plant/$base_topic/alarm/pump -C 1 -W 3 )
echo "$PumpAlarm" 
if [ -z $PumpAlarm ]
then
	PumpAlarm=0
fi

PlantAlarm=$(mosquitto_sub -t plant/$base_topic/alarm/plant -C 1 -W 3 )
echo "$PlantAlarm" 
if [ -z $PlantAlarm ]
then 
	PlantAlarm=1
fi


#Moisture level-in percentage-------------------------------
if [ $MoistureLevel -lt $M_level  ]
then
	mosquitto_pub -t plant/1/remote/led/yellow -m  on
	echo " Moisture below Threshold"
	
fi

#Pump alarm (0)  Plant alarm (1)----------------------------------

if [ $PumpAlarm == 0 ]|| [ $PlantAlarm == 1 ] 
then 
	mosquitto_pub -t plant/$base_topic/remote/led/red -m  on
	echo " ALARM!!! Ring til mor!"
	
fi

#Led Conditions ------------------------------

if [ $MoistureLevel -lt $M_level ]  || [  $PumpAlarm  == 0 ] || [ $PlantAlarm == 1 ]
then
	mosquitto_pub -t plant/$base_topic/remote/led/green -m off
	
	
else 	mosquitto_pub -t plant/$base_topic/remote/led/green -m on
	mosquitto_pub -t plant/$base_topic/remote/led/yellow -m off
	mosquitto_pub -t plant/$base_topic/remote/led/red -m off
	echo "All Good" 
fi

sleep 3 

done 
