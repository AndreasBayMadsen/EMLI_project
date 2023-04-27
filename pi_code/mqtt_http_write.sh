#!/bin/bash
#***********************************************
# This script translates MQTT messages into HTTP
# messages for communication with the ESP.
#
# Command line arguments:
#   - Base topic for the specific plant
#
# The relevant MQTT topcis:
#   - button    (PI <-- ESP)
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
    mosquitto_sub -t "$base_topic/remote/ledRed" -t "$base_topic/remote/ledYellow" -t "$base_topic/remote/ledGreen" -F "%t %p" | while read -r payload
    do
        # Extract data from package
        topic=$(echo "$payload" | cut -d ' ' -f 1)
        msg=$(echo "$payload" | cut -d ' ' -f 2-)

        # Send HTTP GET request
        case $topic in
            "$base_topic/remote/ledRed")
                curl "http://10.42.0.2/led/red/$msg"
                ;;
            
            "$base_topic/remote/ledYellow")
                curl "http://10.42.0.2/led/yellow/$msg"
                ;;
            
            "$base_topic/remote/ledGreen")
                curl "http://10.42.0.2/led/green/$msg"
                ;;
        esac
    done
    sleep 10
done
