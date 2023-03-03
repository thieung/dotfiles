#!/usr/bin/env sh

status() {
	if osascript -e 'tell application "Spotify"
    set playerState to player state as string
end tell
playerState
' | grep -q 'playing'; then
		echo "playing"
	else
		echo "paused"
	fi
}

BACK_SCRIPT="cd $HOME/.config/sketchybar/spotify && ./back.sh"
PAUSE_PLAY_SCRIPT="cd $HOME/.config/sketchybar/spotify/ && ./playpause.sh && source '$PLUGIN_DIR/spotify.sh'"
FORWARD_SCRIPT="cd $HOME/.config/sketchybar/spotify && ./forward.sh"

if [ $(status) = "playing" ]; then
	sketchybar --set spotify_pause icon=''
else
	sketchybar --set spotify_pause icon=''
fi
