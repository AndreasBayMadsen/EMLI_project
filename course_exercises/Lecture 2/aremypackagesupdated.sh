#!/bin/bash
upgradable=$(apt update | grep "upgradable")

if [ ${#upgradable} > 0 ]
then
	echo "yes"
else
	echo "no"
fi
