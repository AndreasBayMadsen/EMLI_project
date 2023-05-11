#!/bin/bash
#***********************************************
# This script checks the number of packets
# sent/received over 'wlan0' and 'eth0'
#***********************************************

# Read from '/proc/net/dev'
eth0_line=($(cat /proc/net/dev | grep "eth0"))
wlan0_line=($(cat /proc/net/dev | grep "wlan0"))

# Extract bytes sent/received
eth0_rx=${eth0_line[1]}
eth0_tx=${eth0_line[1]}
echo $eth0_rx