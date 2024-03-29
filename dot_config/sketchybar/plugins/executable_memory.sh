#!/usr/bin/env bash

MEMORY_USAGE="$(memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f\n", 100-$5"%") }')%"

GREEN=#60ff60
sketchybar -m --set $NAME label="M:$MEMORY_USAGE" label.color=0xff${GREEN:1}
