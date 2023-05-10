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

if [ -z "$base_topic" ]
then
    echo "Error: A base topic must be specified!"
    exit 64
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
                curl "http://10.42.0.2/led/red/$msg"
                ;;
            
            "plant/$base_topic/remote/led/yellow")
                curl "http://10.42.0.2/led/yellow/$msg"
                ;;
            
            "plant/$base_topic/remote/led/green")
                curl "http://10.42.0.2/led/green/$msg"
                ;;
        esac
    done
    sleep 1
done
