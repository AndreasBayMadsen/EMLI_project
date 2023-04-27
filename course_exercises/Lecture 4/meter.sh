#!/bin/bash

max_luminance=1000
min_luminance=150
let luminance_difference=max_luminance-min_luminance

while :
do
	luminance=$(python3 read_mcp3008.py)

	let angle=180*luminance/luminance_difference
	if [[ $angle -ge 180 ]]
	then
		angle=180
	fi

	python3 set_servo_angle.py $angle
	sleep 2
done
