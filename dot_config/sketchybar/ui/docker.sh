#!/usr/bin/env sh

ICON_FONT="sketchybar-app-font"

sketchybar -m --add item docker right                           \
              --set docker update_freq=180                      \
                    icon=":mpv:"                                \
                    icon.padding_right=0                        \
                    label.padding_right=0                       \
                    icon.font="$ICON_FONT:Regular:13"           \
                    script="$PLUGIN_DIR/docker.sh"              \
                    click_script="$PLUGIN_DIR/toggle_docker.sh" \
