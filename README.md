# Radish Watering Project - EMLI Final Project
Implementation of the final project in the course "Embedded Linux.
This code implements an automated radish watering system.
The target platform is a Raspberry Pi running a Debian-based OS (Ubuntu).

## Dependencies
- Mosquitto
- InfluxDB
- Telegraf
- Fail2ban
- nftables
- nmcli

## Install
```
sudo mv pi_code/plant_controller.service  /etc/systemd/system/plant_controller.service
```
```
sudo mv pi_code/*.sh /usr/local/planter/
```
```
sudo mv pi_code/nft_pi_fwIP.nft /usr/local/planter/
```
```
sudo mv pi_code/system_monitor /usr/local/planter/system_monitor
```
```
sudo mv pi_code/logs /usr/local/planter/logs
```
    
## Additonally, for logging data:
- Create InfluxDB database
- Configure Telegraf
- Create Grafana dashboard
