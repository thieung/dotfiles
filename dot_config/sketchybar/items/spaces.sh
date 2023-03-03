#!/usr/bin/env sh

sketchybar \
	--add space www left \
	--set www associated_display=1 \
	label.drawing=off \
	associated_space=1 \
	icon= \
	click_script="yabai -m space --focus browser" \
	background.color=$transparent_color \
	--add space terminal left \
	--set terminal associated_display=1 \
	label.drawing=off \
	associated_space=2 \
	icon= \
	click_script="yabai -m space --focus terminal" \
	background.color=$transparent_color \
	--add space slack left \
	--set slack associated_display=1 \
	label.drawing=off \
	associated_space=3 \
	icon= \
	click_script="yabai -m space --focus chat" \
	background.color=$transparent_color \
	--add space mail left \
	--set mail associated_display=1 \
	label.drawing=off \
	associated_space=4 \
	icon= \
	click_script="yabai -m space --focus mail" \
	background.color=$transparent_color \
	--add space tools left \
	--set tools associated_display=1 \
	label.drawing=off \
	icon.padding_right=6 \
	associated_space=5 \
	icon=󰣆 \
	click_script="yabai -m space --focus tools" \
	background.color=$transparent_color \
	--add space docs left \
	--set docs associated_display=1 \
	label.drawing=off \
	associated_space=6 \
	icon=󱎒 \
	click_script="yabai -m space --focus docs" \
	--add item window_title_logo_display_1 left \
	--set window_title_logo_display_1 associated_display=1 \
	icon= \
	icon.color=$current_app_color \
	icon.font="$NERD_FONT:Semibold:12.0" \
	label.drawing=off
# background.color=$current_app_bg_color

sketchybar \
	--add event window_focus \
	--add event title_change \
	--add item window_title_display_1 left \
	--set window_title_display_1 associated_display=1 \
	icon.drawing=off \
	background.color=$transparent_color \
	script="$PLUGIN_DIR/window_title.sh" \
	--subscribe window_title_display_1 \
	window_focus \
	front_app_switched \
	space_change \
	title_change

sketchybar \
	--add bracket primary_spaces_bracket \
	www \
	slack \
	mail \
	tools \
	window_title_logo_display_1 \
	window_title_display_1 \
	--set primary_spaces_bracket \
	background.color=$bar_bg_color \
	background.border_color=$bar_border_color \
	background.border_width=3 \
	background.corner_radius=8 \
	background.height=32
