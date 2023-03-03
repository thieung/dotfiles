#!/usr/bin/env sh

sketchybar \
	--add item memory right \
	--set memory \
	update_freq=5 \
	icon.drawing=off \
	script="$PLUGIN_DIR/memory.sh" \
	background.color=$transparent_color

sketchybar \
	--add item memory_logo right \
	--set memory_logo icon=󰍛 \
	icon.color=$right_icon_color \
	label.drawing=off \
	background.color=$memory_highlight

sketchybar --add bracket memory_bracket \
	memory \
	memory_logo \
	--set memory_bracket \
	background.color=$bar_bg_color \
	background.border_color=$bar_border_color \
	background.border_width=3 \
	background.corner_radius=8 \
	background.height=33
