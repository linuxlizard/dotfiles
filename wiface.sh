#!/bin/sh
# list wireless interfaces
#
# designed to be used from shell, e.g. :
# 	wpa_sli -i $(wiface 1) status

set -eu

counter=0
for f in /sys/class/net/wl* ; 
do
	. $f/uevent
	if [ $# -eq 0 ] ; 
	then
		echo $counter $INTERFACE 
	else
		if [ $counter -eq $1 ] ; 
		then
			echo $INTERFACE
			break
		fi
	fi

	counter=$((counter+1))
done

