#!/bin/bash
#***********************************************
# This script translates serial data messages into MQTT
# messages for communication with the PICO.
#
# The relevant MQTT topics:
#   - control/pump    		(PI --> PICO)
#***********************************************

# Topic registration
base_topic=$1

if [ -z "$base_topic" ]
then 
    echo "Error:Base topic needs to be defined" 
    exit 64
fi 


# Main loop
mosquitto_sub -t "plant/$base_topic/remote/led/red" -t "plant/$base_topic/remote/led/yellow" -t "plant/$base_topic/remote/led/green" -F "%t %p" | while read -r payload
do
    # Extract data from package
        topic=$(echo "$payload" | cut -d ' ' -f 1)
        msg=$(echo "$payload" | cut -d ' ' -f 2-)

        # Distribute values to variables
        case $topic in
            "plant/$base_topic/alarm/plant")
                plantAlarm=$msg
                ;;
            
            "plant/$base_topic/alarm/pump")
                pumpAlarm=$msg
                ;;
            
            "plant/$base_topic/control/pump")
                pumpControl=$msg
                ;;
        esac

        # Send pump signal
        if [ -e /dev/ttyACM0 ] && [ $pumpControl = 1 ] && [ $pumpAlarm=1 ] && [ $plantAlarm=0 ]
        then
            echo "p" > /dev/ttyACM0
        done
done

