#!/bin/bash
IFS=' '
read -a var <<< $(df / | grep "/")
let var=${var[3]}/1024/1024
echo "$var GB"
