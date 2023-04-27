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
#   - ledGreen  (PI --> ESP)
#   - ledBlue   (PI --> ESP)
#***********************************************

# Extract command line arguments
base_topic=$1

# Listen for 'PI --> ESP' messages
