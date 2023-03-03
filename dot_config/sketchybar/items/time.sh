#!/usr/bin/env sh

sketchybar \
	--add item time right \
	--set time \
	update_freq=10 \
	icon.drawing=off \
	script="$PLUGIN_DIR/clock.sh" \
	background.color=$transparent_color

sketchybar \
	--add item time_logo right \
	--set time_logo icon=󰃰 \
	icon.color=$right_icon_color \
	label.drawing=off \
	background.color=$time_highlight

sketchybar --add bracket time_bracket \
	time \
	time_logo \
	--set time_bracket \
	background.color=$bar_bg_color \
	background.border_color=$bar_border_color \
	background.border_width=3 \
	background.corner_radius=8 \
	background.height=33
