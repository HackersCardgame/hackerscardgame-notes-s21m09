#!/bin/bash

qjackctl -s  &

sleep 3

pactl load-module module-jack-sink channels=4
pactl load-module module-jack-source channels=4

pactl load-module module-loopback latency_msec=1


#jamulus -c 192.168.192.234:6543 &
#Jamulus -c 192.168.192.234 &

#mixxx &

guitarix &

obs &

#orca &

