#!/bin/bash
#***********************************************
# This script checks for internet connection
#***********************************************

# Try to connect to '1.1.1.1'
if nc -zw1 "1.1.1.1" 443
then
    exit 0
else
    exit 1
fi