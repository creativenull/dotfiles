#!/bin/sh

# Reload sketchybar when the theme changes to apply light/dark theme.

if [ "$SENDER" = "theme_change" ]; then
	sketchybar --reload
fi
