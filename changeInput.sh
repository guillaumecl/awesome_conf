#! /bin/sh

deviceId=$(xinput list | grep -A5 "Virtual core keyboard" | grep Keyboard | grep -v TypeMatrix | sed 's/.*id=\([0-9]*\).*/\1/')

setxkbmap -device $deviceId $@
