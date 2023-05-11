#!/bin/bash
#***********************************************
# This script defines constants and settings for
# the radish waterer program
#***********************************************

# Setup for the various radish plants
N_RADISHES=1            # Number of radishes
REMOTE_IPS=(            # IP for each remote
    "10.42.0.2"
)
CONTROLLER_SERIALS=(    # Serial device for each radish
    "/dev/ttyACM0"
)