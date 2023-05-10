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
remote_ip=$2

if [ "$base_topic" = "help" ]
then
    echo "mqtt_http_read [plant id] [remote ip]"
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
    exit 33
fi

# Read from ESP and present on MQTT
while true
do
    button_presses=$(curl -s "http://$remote_ip/button/a/count")
    mosquitto_pub -t "plant/$base_topic/remote/button" -m $button_presses
    sleep 2
done
