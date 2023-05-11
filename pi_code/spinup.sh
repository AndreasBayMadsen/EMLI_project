#!/bin/bash

#..............................
# The script to start all scripts

#....................... 



#--- functions to starts the scripts per plant ---

function start_scripts {



# define names of cmd line inputs
plant_id=$1    #  plant id  is the index of the for loop
serial_dev=${CONTROLLER_SERIAL[plant_id]}  # reads from the config array
remote_ip=${REMOTE_IPS[plant_id]}

# check inputs
if [ -z "$plant_id" ] || [ -z "$serial_dev" ] || [ -z "$remote_ip" ]
then 
        echo "Error: plant id or Serial Device or remote ip  needs to be defined" 
        exit 64
fi 



# start scripts and give inputs and save process id
./mqtt_serial_read $plant_id $serial_dev & 
PID_plant+=($!)				# save process id in array 

./mqtt_serial_write.sh $plant_id $serial_dev &
PID_plant+=($!)

./mqtt_http_read.sh $plant_id $remote_ip &
PID_plant+=($!)

./mqtt_http_write.sh $plant_id $remote_ip &
PID_plant+=($!)

./button_water.sh $plant_id &
PID_plant+=($!)

./moisture_controller.sh $plant_id &
PID_plant+=($!)

./moisture_alarm.sh $pant_id &
PID_plant+=($!)

./green_led.sh $plant_id &
PID_plant+=($!)

./yellow_led.sh $plant_id &
PID_plant+=($!)

./red_led.sh $plant_id
PID_plant+=($!)

echo ${PID_plant[*]}

}


for(( i=0 ; i< N_RADISES; i++ )) 

do


buffer=$(start_scripts $i )     # reads output array of script function with process ids
PID_plant_array+=($buffer)	# makes vector of process ids

done



































while :
do
        for (( i = 0; i < N_RADISES; i++ ))
        do
                for (( j = 0; j < scriptCount; j++ ))
                do
                        let n=$i*2+$j
                        if ! ps -p ${PID[n]} > /dev/null
                        then
                                echo "Plant $i scripts have failed at script $j"
                                echo "Killing all applicaple plant scripts"
                                for (( k = 0; k < scriptCount; k++ ))
                                do
                                        let n=$i*2+$k
                                        #kill ${PID[n]}
                                        echo "kill PID ${PID[n]}"
                                done
                                echo "Restarting scripts"
                                #temp_pid=($(start_scripts(i)))
                                for (( k = 0; k < scriptCount; k++ ))
                                do
                                        let n=$i*2+$k
                                        PID[n]=${temp_pid[k]}
                                done
                                echo "Restart done"

                        else
                                echo "PID ${PID[n]} good"
                        fi
                done  
        done
        echo "Checking Monitor script"
        if ! ps -p $monitor_PID > /dev/null
        then
                ./logging/system_monitor.sh &
                monitor_PID=$!
        fi
        echo "Sleeping for 10s"
        sleep 10
done