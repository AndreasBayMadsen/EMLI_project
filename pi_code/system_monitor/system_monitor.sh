#!/bin/bash

cd "$(dirname "$0")"	# Change directory

networkStatisticsLast=($(./network_performance.sh))	# For calculating network speed
timeLast=$(date +%s)
while :
do
	echo "Doing a system Scan"
	echo "------------------------------------------"

	availableDisk=$(./available_disk.sh)
	echo "-- Available disk space: $availableDisk% "
	mosquitto_pub -m $availableDisk -t "system/availableDisk"

	availableRam=$(./available_ram.sh)
	echo "-- Available RAM space: $availableRam%"
	mosquitto_pub -m $availableRam -t "system/availableRam"

	CPULoad=$(./cpu_load.sh)
	echo "-- CPU load: $CPULoad%"
	mosquitto_pub -m $CPULoad -t "system/cpuLoad"

	CPUTemp=$(./available_ram.sh)
	echo "-- CPU temperature: $CPUTemp °C "
	mosquitto_pub -m $CPUTemp -t "system/cpuTemp"

	if ./internet_connection.sh 
	then
		echo "-- Internet is available"
		mosquitto_pub -m 1 -t "system/internet"
	else
		echo "-- Internet is disconnected"
		mosquitto_pub -m 0 -t "system/internet"
	fi
	networkStatistics=($(./network_performance.sh))
	timeNow=$(date +%s)
	let deltaTime=$timeNow-$timeLast


	echo "-- eth0:"
	echo "  - Bytes recieved: ${networkStatistics[2]}"
	mosquitto_pub -m ${networkStatistics[2]} -t "system/eth0RxBytes"
	echo "  - Bytes sent: ${networkStatistics[5]}"
	mosquitto_pub -m ${networkStatistics[5]} -t "system/eth0TxBytes"
	uploadSpeedEth=$(echo "scale = 0; (${networkStatistics[2]} - ${networkStatisticsLast[2]}) / ($deltaTime)" | bc)
	echo "  - Upload speed: $uploadSpeedEth B/s"
	mosquitto_pub -m $uploadSpeedEth -t "system/eth0RxSpeed"
	downloadSpeedEth=$(echo "scale = 0; (${networkStatistics[5]} - ${networkStatisticsLast[5]}) / ($deltaTime) " | bc)
	echo "  - Download speed: $downloadSpeedEth B/s"
	mosquitto_pub -m $downloadSpeedEth -t "system/eth0TxSpeed"

	echo "-- wlan0:"
	echo "  - Bytes recieved: ${networkStatistics[8]}"
	mosquitto_pub -m ${networkStatistics[8]} -t "system/wlan0RxBytes"
	echo "  - Bytes sent: ${networkStatistics[11]}"
	mosquitto_pub -m ${networkStatistics[11]} -t "system/wlan0TxBytes"
	uploadSpeedWlan=$(echo "scale = 0; (${networkStatistics[8]} - ${networkStatisticsLast[8]}) / ($deltaTime) " | bc)
	echo "  - Upload speed: $uploadSpeedWlan B/s"
	mosquitto_pub -m $uploadSpeedWlan -t "system/wlan0RxSpeed"
	downloadSpeedWlan=$(echo "scale = 0; (${networkStatistics[11]} - ${networkStatisticsLast[11]}) / ($deltaTime) " | bc)
	echo "  - Download speed: $downloadSpeedWlan B/s"
	mosquitto_pub -m $downloadSpeedWlan -t "system/wlan0TxSpeed"

	networkStatisticsLast=($(echo ${networkStatistics[*]}))




	sleep 5s
done