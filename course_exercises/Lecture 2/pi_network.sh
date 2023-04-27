#!/bin/bash
iptables -t nat -F
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o wlp2s0 -j MASQUERADE
