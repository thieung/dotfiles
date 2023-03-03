#!/usr/bin/env sh

sketchybar --set $NAME label="$(df -lh | grep /dev/disk1s2 | awk '{ printf ("%02.0f\n", $5) }')%"
