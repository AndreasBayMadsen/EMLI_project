#!/usr/bin/env python3
# https://github.com/olavolav/uniplot
# Prerequisites:
# pip3 install uniplot
# Usage example:
# echo 1,2,3,4.2,5.0,3.6 | ./shellplot.py
# 2023-02-21 Kjeld Jensen <kjen@sdu.dk>
from uniplot import plot
import sys # read a list of numbers from stdin

for line in sys.stdin:
	lst = line.rstrip().split(",")
	# convert a list of strings to a list of floats
	lst_num = list(map(float, lst))
	# plot the float numbers
	plot(lst_num, lines=True)
