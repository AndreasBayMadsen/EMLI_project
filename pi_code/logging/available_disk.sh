#!/bin/bash
#***********************************************
# This script returns the available disk space
# in percent
#***********************************************

# Read data from 'df'
data=$(df / | grep /)
data=($data)

# Extract total and available
total=${data[1]}
available=${data[2]}

# Calculate available percentage
res=$(bc <<< "scale=0; $available*100/$total")

# Return result
echo $res