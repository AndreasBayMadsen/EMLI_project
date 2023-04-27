#!/bin/bash
log_pth=/home/pi/cron_log.txt

tim=$(date)
arg=$1

echo "$tim        $arg" >> $log_pth
