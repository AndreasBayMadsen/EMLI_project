#!/bin/bash
outp=$(df -h | grep "/dev/root")
arr=($outp)
used_perc=$(echo ${arr[4]} | tr -d %)
available_perc=$((100-$used_perc))
echo "Available disk: $available_perc%"
