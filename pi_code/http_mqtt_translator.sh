#!/bin/bash
#***********************************************
# This script translates MQTT messages into HTTP
# messages for communication with the ESP.
#
# The relevant MQTT topcis:
#   - Button    (PI <-- ESP)
#   - LED_RED   (PI --> ESP)
#   - LED_GREEN (PI --> ESP)
#   - LED_BLUE  (PI --> ESP)
#***********************************************

# Extract command line arguments
base_topic = "Hey"
echo $base_topic

# Listen for 'PI --> ESP' messages
