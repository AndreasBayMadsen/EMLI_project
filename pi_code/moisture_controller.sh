#!/bin/bash
#***********************************************
# This script monitors the soil's moistness and
# activates the pump in case it is too low.
#
# Command line arguments:
#   - Base topic for the specific plant
#
# The relevant MQTT topcis:
#   - sensor/moisture   (PI <-- ESP)
#   - pump
#***********************************************

# Constant definitions
CRITICAL_MOISTNESS=40
HOUR_12=43200
HOUR=3600

# Extract command line arguments
base_topic=$1

if [ -z "$base_topic" ]
then
    echo "Error: A base topic must be specified!"
    exit 64
fi

# Initialize variables
let last_pump_time=$(date +%s)-3600 # One hour ago

# Read and react to moistness
while true
do
    moistness=$(mosquitto_sub -t "plant/$base_topic/sensor/moisture" -C 1 -W 60)
    let time_from_last_pump=$(date +%s)-$last_pump_time # Update timing

    # Check for MQTT timeout
    if ! [ -z $moistness ]
    then
        # Decide if water is needed
        if [ $moistness -lt $CRITICAL_MOISTNESS ] && [ $time_from_last_pump -gt $HOUR ]
        then
            last_pump_time=$(date +%s)  # Update last pump time
            mosquitto_pub -t "plant/$base_topic/control/pump" -m 1
        fi
    fi

    # Decide if 12 hour limit is reached
    if [ $time_from_last_pump -ge $HOUR_12 ]
    then
        last_pump_time=$(date +%s)  # Update last pump time
        mosquitto_pub -t "plant/$base_topic/control/pump" -m 1
    fi
done