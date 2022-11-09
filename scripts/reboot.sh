#!/bin/bash

echo "Rebooting, abort by pressing 'CTRL + C'"
for i in {10..1}
do
	if [ "$i" -eq "1" ]; then
		echo -en "\rRebooting in $i second... "
	else
		echo -en "\rRebooting in $i seconds..."
	fi
	sleep 1
done

reboot
