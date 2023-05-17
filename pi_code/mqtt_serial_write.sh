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
dev=$2

if [ "$base_topic" = "help" ]
then
    echo "mqtt_serial_write [plant id] [device location]"
    exit 0
fi

if [ -z "$base_topic" ]
then 
    echo "Error: Base topic needs to be defined" 
    exit 64
fi 

if [ -z "$dev" ]
then
    echo "Error: An I/O device needs to be specified!"
    exit 32
fi


# Main loop
mosquitto_sub -t "plant/$base_topic/alarm/plant" -t "plant/$base_topic/alarm/pump" -t "plant/$base_topic/control/pump" -F "%t %p" | while read -r payload
do
    # Allow no variables to be empty
    if [ -z $plantAlarm ]
    then
        plantAlarm=1
    fi

    if [ -z $pumpAlarm ]
    then
        pumpAlarm=0
    fi

    if [ -z $pumpControl ]
    then
        pumpControl=0
    fi

    # Extract data from package
        topic=$(echo "$payload" | cut -d ' ' -f 1)
        msg=$(echo "$payload" | cut -d ' ' -f 2-)

        # Reset pump control
        pumpControl=0

        # Distribute values to variables
        if [ $msg=1 ] | [ $msg=0 ]
        then
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
        fi

        # Send pump signal
        if [ -e $dev ] && [ $pumpControl = 1 ] && [ $pumpAlarm = 1 ] && [ $plantAlarm = 0 ]
        then
            echo "Pumping water $(date)"
            echo "p" > $dev
	    mosquitto_pub -t "plant/$base_topic/control/pump_activations" -m 1
        fi
done

