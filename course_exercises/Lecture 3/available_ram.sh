#!/bin/bash
outp=$(free -m | grep "Mem")
arr=($outp)
total_ram=${arr[1]}
available_ram=${arr[6]}
available_perc=$(((100*available_ram) / total_ram))
echo "Available ram: $available_perc%"
