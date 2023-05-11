#!/bin/bash


#.......................................

#Red Led should light up if the pump is out of water

#.......................................


base_topic=$1


# check if base topic is created
if [ -z "$base_topic" ]
then 
        echo "Error:Base topic needs to be defined" 
        exit 64
fi 

while :
do
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



        if [ $PumpAlarm -eq 0 ] || [ $PlantAlarm -eq 1 ] 
        then 
                mosquitto_pub -t plant/$base_topic/remote/led/red -m  on
                echo " ALARM!!! Ring til mor!. $(date)"
        else 
                mosquitto_pub -t plant/$base_topic/remote/led/red -m  off

        fi

done 
