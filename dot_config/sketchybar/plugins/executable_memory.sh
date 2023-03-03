#!/usr/bin/env sh

# getPrecentage=$(
# 	TARGET_PATH="."
# 	top -l 1 | grep -E "^CPU" | grep -Eo '[^[:space:]]+%' | head -1 | sed 's/3\(.\)$/\1/' | cut -d "." -f1
# )
#
# getMB=$(
# 	TARGET_PATH="."
# 	top -l1 | awk '/PhysMem/ {print $2}'
# )
#
# precentage=$(echo $getPrecentage)
# MB=$(echo $getMB)
#
# sketchybar --set $NAME label="$precentage%"
sketchybar --set $NAME label=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f\n", 100-$5"%") }')%
