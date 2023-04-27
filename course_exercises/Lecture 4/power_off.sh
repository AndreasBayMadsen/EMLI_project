#!/bin/bash

count=0
while :
do
	# Read switch
	switch_state=$(sh ./read_switch.sh)

	if [[ $switch_state == "ON" ]]
	then
		let count=$count+1
	else
		count=0
	fi

	sleep 1

	if [[ $count -eq 3 ]]
	then
		poweroff
	fi
done
