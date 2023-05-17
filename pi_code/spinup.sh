#!/bin/bash

#..............................
# The script to start all scripts

#....................... 

# ---------- INCLUDES ---------- #
cd "$(dirname "$0")"	# Change directory
source configuration.sh

# ---------- FUNCTION DECLARATIONS ---------- #
# Function to start all the sub-scripts for a single plant
function start_scripts {
        # define names of cmd line inputs
        plant_id=$1    #  plant id  is the index of the for loop
        serial_dev=${CONTROLLER_SERIALS[plant_id]}  # reads from the config array
        remote_ip=${REMOTE_IPS[plant_id]}

        # check inputs
        if [ -z "$plant_id" ] || [ -z "$serial_dev" ] || [ -z "$remote_ip" ]
        then 
                echo "Error: plant id or Serial Device or remote ip  needs to be defined" 
                exit 64
        fi

        # Start scripts, give inputs and save process IDs
        nohup ./mqtt_serial_read.sh $plant_id $serial_dev &>./logs/mqtt_serial_read_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)       # save process id in array

        nohup ./mqtt_serial_write.sh $plant_id $serial_dev &>./logs/mqtt_serial_write_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        sudo -u plant nohup ./mqtt_http_read.sh $plant_id $remote_ip &>./logs/mqtt_http_read_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        sudo -u plant nohup ./mqtt_http_write.sh $plant_id $remote_ip &>./logs/mqtt_http_write_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        sudo -u plant nohup ./button_water.sh $plant_id &>./logs/button_water_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        sudo -u plant nohup ./moisture_controller.sh $plant_id &>./logs/moisture_controller_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        sudo -u plant nohup ./moisture_alarm.sh $plant_id &>./logs/moisture_alarm_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        sudo -u plant nohup ./green_led.sh $plant_id &>./logs/green_led_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        sudo -u plant nohup ./yellow_led.sh $plant_id &>./logs/yellow_led_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        sudo -u plant nohup ./red_led.sh $plant_id &>./logs/red_led_$plant_id.log &
        PID=$!
        echo $PID >> ./logs/PIDs.log
        PID_plant+=($PID)

        echo ${PID_plant[*]}

}

# ---------- MAIN PROGRAM ---------- #
# Bootup procedure
echo "Starting access point."
./nft_pi_fwIP.nft               # Set up firewall
nmcli d wifi hotspot ifname wlan0 ssid EMLI_TEAM_12 password raspberry

# Start up all processes
for(( i=0 ; i< N_RADISHES; i++ )) 
do
        buffer=$(start_scripts $i)      # reads output array of script function with process ids
        PID_plant_array+=($buffer)	# makes vector of process ids
done

# Start up monitoring process
sudo -u plant nohup ./system_monitor/system_monitor.sh &>./logs/system_monitor.log &
monitor_PID=$!

systemd-notify --ready --status="started"

# Monitor running processes
scriptCount=${#PID_plant_array[@]}      # Number of scripts per plant
while :
do
        for (( i = 0; i < N_RADISHES; i++ ))
        do
                for (( j = 0; j < scriptCount; j++ ))
                do
                        let n=$i*$scriptCount+$j        # 1D-index of the script in question
                        if ! ps -p ${PID_plant_array[n]} > /dev/null
                        then
                                echo "Plant $i scripts have failed at script $j"
                                echo "Killing all applicaple plant scripts"
                                for (( k = 0; k < scriptCount; k++ ))
                                do
                                        let n=$i*$scriptCount+$k
                                        echo "kill PID ${PID_plant_array[n]}"
                                        kill ${PID_plant_array[n]}
                                done
                                
                                echo "Restarting scripts"
                                temp_pid=($(start_scripts $i))
                                for (( k = 0; k < scriptCount; k++ ))
                                do
                                        let n=$i*scriptCount+$k
                                        PID_plant_array[n]=${temp_pid[k]}
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
                echo "Monitor script stopped!"
                echo "Restarting monitor script"
                sudo -u plant nohup ./system_monitor/system_monitor.sh &>./logs/system_monitor.log &
                monitor_PID=$!
        fi
        echo "Sleeping for 10s"
        sleep 10
done
