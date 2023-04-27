#!/bin/bash
#***********************************************
# This script listens for the remote's button
# inputs and requests pump action.
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

# Listen for messages
while true
do
    payload=$(mosquitto_sub -t "plant/$base_topic/remote/button" -C 1)
    
    if [ $payload = 1 ]
    then
        mosquitto_pub -t "plant/$base_topic/control/pump" -m 1
    fi
done