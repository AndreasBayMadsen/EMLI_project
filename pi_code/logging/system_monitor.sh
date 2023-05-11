#!/bin/bash

networkStatisticsLast=($(./network_performance.sh))
while :
do
	echo "Doing a system Scan"
	echo "------------------------------------------"

	availableDisk=$(./available_disk.sh)
	echo "-- Available disk space: $availableDisk% "

	availableRam=$(./available_ram.sh)
	echo "-- Available RAM space: $availableRam%"

	CPULoad=$(./cpu_load.sh)
	echo "-- CPU load: $CPULoad%"

	CPUTemp=$(./available_ram.sh)
	echo "-- CPU temperature: $CPUTemp °C "

	if ./internet_connection.sh 
	then
		echo "-- Internet is available"
	else
		echo "-- Internet is disconnected"
	fi
	networkStatistics=($(./network_performance.sh))
	echo "-- eth0:"
	echo "  - Bytes recieved: ${networkStatistics[2]}"
	echo "  - Bytes sent: ${networkStatistics[5]}"
	uploadSpeedEth=$(echo "scale = 0; (${networkStatistics[2]} - ${networkStatisticsLast[2]}) / 5" | bc)
	echo "  - Upload speed: $uploadSpeedEth B/s"
	downloadSpeedEth=$(echo "scale = 0; (${networkStatistics[5]} - ${networkStatisticsLast[5]}) / 5 " | bc)
	echo "  - Download speed: $downloadSpeedEth B/s"

	echo "-- wlan0:"
	echo "  - Bytes recieved: ${networkStatistics[8]}"
	echo "  - Bytes sent: ${networkStatistics[11]}"
	uploadSpeedWlan=$(echo "scale = 0; (${networkStatistics[8]} - ${networkStatisticsLast[8]}) / 5 " | bc)
	echo "  - Upload speed: $uploadSpeedWlan B/s"
	downloadSpeedWlan=$(echo "scale = 0; (${networkStatistics[11]} - ${networkStatisticsLast[11]}) / 5 " | bc)
	echo "  - Download speed: $downloadSpeedWlan B/s"
	networkStatisticsLast=($(echo ${networkStatistics[*]}))




	sleep 5s
done