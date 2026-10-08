#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

if [ "$SELECTED" = "true" ]; then
    sketchybar --animate sin 15 --set "$NAME" background.color=0xffffffff icon.highlight=on
else
    sketchybar --animate sin 15 --set "$NAME" background.color=0x88262626 icon.highlight=off
fi
