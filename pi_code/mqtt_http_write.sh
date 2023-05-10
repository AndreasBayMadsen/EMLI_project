#!/bin/bash
#***********************************************
# This script translates MQTT messages into HTTP
# messages for communication with the ESP.
#
# Command line arguments:
#   - Base topic for the specific plant
#
# The relevant MQTT topcis:
#   - ledRed    (PI --> ESP)
#   - ledYellow (PI --> ESP)
#   - ledGreen  (PI --> ESP)
#***********************************************

# Extract command line arguments
base_topic=$1
remote_ip=$2

if [ "$base_topic" = "help" ]
then
    echo "mqtt_http_write [plant id] [remote ip]"
    exit 0
fi

if [ -z "$base_topic" ]
then
    echo "Error: A base topic must be specified!"
    exit 64
fi

if [ -z "$remote_ip" ]
then
    echo "Error: An needs to be specified for the remote!"
    exit 32
fi

# Listen for 'PI --> ESP' messages
while true
do
    mosquitto_sub -t "plant/$base_topic/remote/led/red" -t "plant/$base_topic/remote/led/yellow" -t "plant/$base_topic/remote/led/green" -F "%t %p" | while read -r payload
    do
        # Extract data from package
        topic=$(echo "$payload" | cut -d ' ' -f 1)
        msg=$(echo "$payload" | cut -d ' ' -f 2-)

        # Send HTTP GET request
        case $topic in
            "plant/$base_topic/remote/led/red")
                curl "http://$remote_ip/led/red/$msg"
                ;;
            
            "plant/$base_topic/remote/led/yellow")
                curl "http://$remote_ip/led/yellow/$msg"
                ;;
            
            "plant/$base_topic/remote/led/green")
                curl "http://$remote_ip/led/green/$msg"
                ;;
        esac
    done
    sleep 1
done
