#!/usr/bin/env sh

PLAYING=$(cd $HOME/.config/sketchybar/spotify && ./song.sh)
ARTIST=$(cd ~/.config/sketchybar/spotify && ./artist.sh)
ALBUM=$(cd ~/.config/sketchybar/spotify && ./album.sh)
# BOTH=$(echo $PLAYING && echo " • " && echo $ARTIST)
# FINAL=$(echo $BOTH | sed 's/\(.\{40\}\).*/\1.../')

if [ -z "$PLAYING" ]; then
	sketchybar --set '/spot.*/' drawing=off
else
	if [ "$ARTIST" == "" ]; then
		sketchybar --set $NAME label="$PLAYING - $ALBUM" --set '/spot.*/' drawing=on
	else
		sketchybar --set $NAME label="$PLAYING - $ARTIST" --set '/spot.*/' drawing=on
	fi
	# sketchybar --set $NAME label="$FINAL   | " --set '/spot.*/' drawing=on
fi
