#!/bin/bash
#***********************************************
# This script returns the available disk space
# in percent
#***********************************************

# Read data from 'top'
data=($(top -bn1 | grep "Cpu"))



# Find percentage of time spent idle/not idle
idle_perc=$(echo ${data[7]} | tr . ,)
let load_perc=100-$idle_perc

echo $load_perc