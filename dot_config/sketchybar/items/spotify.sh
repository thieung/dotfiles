#!/usr/bin/env sh

source "$PLUGIN_DIR/spotify.sh"

sketchybar \
	--add item spotify_anchor center \
	--set spotify_anchor \
	icon= \
	icon.color=$right_icon_color \
	background.color=$music_highlight \
	associated_display="${DISPLAY_COUNT}" \
	label.drawing=off

sketchybar \
	--add item spotify_playing center \
	--set spotify_playing \
	icon= \
	icon.color=$music_highlight \
	associated_display="${DISPLAY_COUNT}" \
	update_freq=2 \
	updates=on \
	script="$PLUGIN_DIR/spotify_playing.sh" \
	label.font="$SPECIAL_FONT:Regular:15.0" \
	label.padding_left=2 \
	label.y_offset=1 \
	background.color=$transparent_color

sketchybar \
	--add item spotify_back center \
	--set spotify_back \
	icon=􀊎 \
	icon.font="$NERD_FONT:Regular:15.0" \
	icon.color=$BLUE \
	icon.padding_left=10 \
	icon.padding_right=25 \
	background.drawing=on \
	click_script="$BACK_SCRIPT" \
	y_offset=1 \
	--subscribe spotify_back mouse.clicked

sketchybar \
	--add item spotify_pause center \
	--set spotify_pause \
	icon= \
	icon.font="$NERD_FONT:Regular:15.0" \
	icon.color=$GREEN \
	icon.padding_right=20 \
	background.padding_left=-25 \
	background.drawing=on \
	click_script="$PAUSE_PLAY_SCRIPT" \
	script="$PLUGIN_DIR/spotify.sh" \
	update_freq=2 \
	y_offset=1 \
	--subscribe spotify_pause mouse.clicked

sketchybar \
	--add item spotify_forward center \
	--set spotify_forward \
	icon=􀊐 \
	icon.font="$NERD_FONT:Regular:15.0" \
	icon.color=$BLUE \
	icon.padding_left=5 \
	background.padding_left=-23 \
	background.drawing=on \
	click_script="$FORWARD_SCRIPT" \
	y_offset=1 \
	--subscribe spotify_forward mouse.clicked

sketchybar \
	--add bracket spotify_bracket \
	spotify_anchor \
	spotify_playing \
	spotify_back \
	spotify_pause \
	spotify_forward \
	--set spotify_bracket \
	background.color=$bar_bg_color \
	background.border_color=$bar_border_color \
	background.border_width=3 \
	background.corner_radius=8 \
	background.height=32
