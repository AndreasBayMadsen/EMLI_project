#!/bin/bash
log=$(tail -n 60 /var/www/html/log.txt)
arr=($log)
length=${#arr[@]}

# Create list of values
idx=0
while [ $idx -lt $length ]
do
	outp_arr+=(${arr[idx+4]})
	let idx=$idx+5
done

# Create comma separated string
printf -v number_list '%s,' "${outp_arr[@]}"

# Plot data
echo "${number_list%,}" | ./shellplot.py
