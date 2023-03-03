#!/usr/bin/env bash

WINDOW_TITLE=$(yabai -m query --windows --window | jq -r '.app')

sketchybar -m --set $NAME label="${WINDOW_TITLE}"
