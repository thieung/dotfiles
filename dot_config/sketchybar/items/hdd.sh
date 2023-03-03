#!/usr/bin/env sh

sketchybar \
	--add item disk right \
	--set disk \
	update_freq=5 \
	icon.drawing=off \
	script="$PLUGIN_DIR/disk.sh" \
	background.color=$transparent_color

sketchybar \
	--add item disk_logo right \
	--set disk_logo icon= \
	icon.color=$right_icon_color \
	label.drawing=off \
	background.color=$disk_highlight

sketchybar --add bracket disk_bracket \
	disk \
	disk_logo \
	--set disk_bracket \
	background.color=$bar_bg_color \
	background.border_color=$bar_border_color \
	background.border_width=3 \
	background.corner_radius=8 \
	background.height=33
