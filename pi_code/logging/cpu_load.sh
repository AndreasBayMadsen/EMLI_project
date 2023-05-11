#!/bin/bash
#***********************************************
# This script returns the available disk space
# in percent
#***********************************************

# Read data from 'top'
data=$(top -bn1 | grep "Cpu")
data=($data)

# Find percentage of time spent idle/not idle
idle_perc=${data[7]}
load_perc=$(bc <<< "scale=2; 100-$idle_perc")

echo $load_perc