#!/bin/bash
#***********************************************
# This script checks the number of packets
# sent/received over 'wlan0' and 'eth0'
#***********************************************

# Read from '/proc/net/dev'
eth0_line=($(cat /proc/net/dev | grep "enp5s0"))
wlan0_line=($(cat /proc/net/dev | grep "wlp4s0"))

# Extract bytes sent/received
eth0_rx=${eth0_line[1]}
eth0_tx=${eth0_line[9]}

wlan0_rx=${wlan0_line[1]}
wlan0_tx=${wlan0_line[9]}

# Return results
echo "eth0 RX: $eth0_rx"
echo "eth0 TX: $eth0_tx"
echo "wlan0 RX: $wlan0_rx"
echo "wlan0 TX: $wlan0_tx"