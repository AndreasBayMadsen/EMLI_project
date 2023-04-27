#!/bin/bash
#***********************************************
# This script translates HTTP messages into MQTT
# messages for communication with the ESP.
#
# Command line arguments:
#   - Base topic for the specific plant
#
# The relevant MQTT topcis:
#   - button    (PI <-- ESP)
#***********************************************

# Extract command line arguments
base_topic=$1

if [ -z "$base_topic" ]
then
    echo "Error: A base topic must be specified!"
    exit 64
fi

# Read from ESP and present on MQTT
while true
do
    button_presses=$(curl -s "http://10.42.0.2/button/a/count")
    mosquitto_pub -t "$base_topic/remote/button" -m $button_presses
    sleep 2
done
