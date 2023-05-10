#!/bin/bash 

#.....................................................
#Green LED should be active  when all is good 

#

# 
#....................................................

base_topic=$1


# check if base topic is created
if [ -z "$base_topic" ]
then 
        echo "Error:Base topic needs to be defined" 
        exit 64
fi 


while :
do

m1=$(mosquitto_sub -t plant/$base_topic/alarm/pump -C 1 -W 2)
m2=$(mosquitto_sub -t plant/$base_topic/alarm/plant -C 1 -W 2)
m3=$(mosquitto_sub -t plant/$base_topic/alarm/moisture -C 1 -W 2)



#Led Conditions ------------------------------

if [ $m3 == 1 ]  || [  $m1  == 0 ] || [ $m3 == 1 ]
then
        mosquitto_pub -t plant/$base_topic/remote/led/green -m off

else 
	mosquitto_pub -t plant/$base_topic/remote/led/green -m on
	echo " all ok " 
fi

done 
