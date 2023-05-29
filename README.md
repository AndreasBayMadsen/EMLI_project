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
```
sudo mv pi_code/configuration_files/telegraf.conf /etc/telegraf/
```
```
sudo mv pi_code/configuration_files/jail.local /etc/fail2ban/
```
   
## Additonally, for logging data:
- Create InfluxDB database
    - Name: radish_waterer
    - Create user 'telegraf' with password 'emli'
    - Grant all rights to the database to the 'telegraf' user
- Create Grafana data source
    - Name: Radish waterer
    - URL: http://localhost:8086
    - Database: radish_waterer
    - User: telegraf
    - Password: emli
- Create Grafana dashboard
    - Import dashboard file: "pi_code/configuration_files/Radish waterer-1685382794843.json"
