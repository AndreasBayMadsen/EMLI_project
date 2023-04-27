#!/bin/bash
DIR_BIN=$(dirname $(readlink -f $0))
cd $DIR_BIN

tid=$(date +%s)

cpu_temp=$(sh ./cpu_temp.sh)
arr=($cpu_temp)
cpu_temp=${arr[2]}

echo "$tid, $cpu_temp" >> "cpu_temp_logging.csv"
