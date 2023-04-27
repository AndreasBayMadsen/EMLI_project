#!/bin/bash
while read line
do
	if [ ! -z $line ]
	then
		echo "Pico temperature: $line"
	fi
done < /dev/ttyACM0
