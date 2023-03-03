#!/usr/bin/env sh

sketchybar \
	--add item cpu right \
	--set cpu \
	update_freq=5 \
	icon.drawing=off \
	script="$PLUGIN_DIR/cpu.sh" \
	background.color=$transparent_color \
	click_script="open -a activity\ monitor"

sketchybar \
	--add item cpu_logo right \
	--set cpu_logo icon=󰻠 \
	icon.color=$right_icon_color \
	label.drawing=off \
	background.color=$cpu_highlight

sketchybar --add bracket cpu_bracket \
	cpu \
	cpu_logo \
	--set cpu_bracket \
	background.color=$bar_bg_color \
	background.border_color=$bar_border_color \
	background.border_width=3 \
	background.corner_radius=8 \
	background.height=33
