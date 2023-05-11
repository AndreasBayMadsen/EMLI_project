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
res=$(bc <<< "scale=2; $available/$total*100")

# Return result
echo $res