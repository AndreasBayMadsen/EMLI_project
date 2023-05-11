#!/bin/bash
#***********************************************
# This script returns the available RAM in
# percent
#***********************************************

# Read data from 'free'
data=$(free | grep Mem)
data=($data)

# Extract total and available
total=${data[1]}
available=${data[6]}

# Calculate available percentage
res=$(bc <<< "scale=0; $available*100/$total")

# Return result
echo $res