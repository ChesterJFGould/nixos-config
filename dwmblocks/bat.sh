#! /bin/sh

echo "$(cat /sys/class/power_supply/BAT0/capacity) $(cat /sys/class/power_supply/BAT1/capacity)"
