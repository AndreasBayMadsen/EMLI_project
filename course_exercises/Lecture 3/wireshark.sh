#!/bin/bash
line=$(cat /proc/net/dev | grep "eth0")
arr=($line)
RX=${arr[1]}
TX=${arr[9]}
echo "eth0 TX: $TX bytes"
echo "eth0 RX: $RX bytes"
