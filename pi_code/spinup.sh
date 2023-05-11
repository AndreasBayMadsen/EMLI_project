#!/bin/bash

#..............................
# The script to start all scripts

#.............................

 
# define names of cmd line inputs
#plant_id=$1    #  plant id  is the index of the for loop
#serial_dev=$2
#remote_ip=$3

# check inputs
if [ -z "$serial_dev" ] || [ -z "$remote_ip" ]
then 
        echo "Error: Serial Device or remote ip  needs to be defined" 
        exit 64
fi 

for(( i=1 ; i< N_RADISES+1; i++ )) 


# start scripts and give inputs
./mqtt_serial_read $i $serial_dev &
PID_ser_read($i)=$!
./mqtt_serial_write.sh $i $serial_dev &
PID_ser_write($i)=$!
./mqtt_http_read.sh $i $i &
PID_http_read($i)=$!
./mqtt_http_write.sh  $plant_id $remote_ip
./button_water.sh $plant_id 
./moisture_controller.sh $plant_id
./moisture_alarm.sh $plant_id
./green_led.sh $plant_id
./yellow_led.sh $plant_id
./red_led.sh $plant_id

done
