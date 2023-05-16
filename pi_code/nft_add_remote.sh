#!/bin/bash 


# adds a remote ip as acception to the base_filter in nft


remote_ip=$1
# or read ip addres
# read remote_ip


nft add rule inet  base_filter sys_input tcp dport 80 ip saddr $remote_ip ct state new,established accept
