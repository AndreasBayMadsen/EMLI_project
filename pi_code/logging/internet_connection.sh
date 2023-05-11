#!/bin/bash
#***********************************************
# This script checks for internet connection
#***********************************************

# Try to connect to '1.1.1.1'
if nc -zw1 "1.1.1.1" 443
then
    echo "1"
else
    echo "0"
fi