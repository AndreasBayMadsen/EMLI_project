#!/bin/bash
outp=$(top -bn1 | grep "Cpu")
arr=($outp)
idle_perc=${arr[7]}
load_perc=$(echo | awk -v i=$idle_perc '{print 100 - i}')
echo "CPU load: $load_perc%"
