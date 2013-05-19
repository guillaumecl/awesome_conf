#! /bin/sh

deviceIds=$(xinput list | grep -A9 "Virtual core keyboard" | egrep 'USB|AT' | grep -v TypeMatrix | sed 's/.*id=\([0-9]*\).*/\1/')

for deviceId in $deviceIds
do
	setxkbmap -device $deviceId $@
done

