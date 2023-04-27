#!/bin/bash
ping_output=$(ping -c 1 1.1.1.1 | grep "Unreachable")

if [ ${#ping_output} -gt 1 ]
then
	echo "internet: no"
else
	echo "internet: yes"

	ping_output=$(ping -c 1 -W 1 google.com | grep "failure")
	if [ ${#ping_output} -gt 1 ]
	then
		echo "dns: no"
	else
		echo "dns: yes"
	fi
fi
