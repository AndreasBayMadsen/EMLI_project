#!/bin/bash

data=$(wget https://kjen.dk/courses/emli/co2/ -q -O -)
co2=$(echo $data | jq '.[].co2')
co2=($co2)

# Create comma separated string
printf -v number_list '%s,' "${co2[@]}"

# Plot data
echo "${number_list%,}" | ./shellplot.py
