#!/bin/sh

# Reload sketchybar when the theme changes to apply light/dark theme.

if [ "$SENDER" = "theme_change" ] || [ "$SENDER" = "system_woke" ]; then
	sketchybar --reload
fi
