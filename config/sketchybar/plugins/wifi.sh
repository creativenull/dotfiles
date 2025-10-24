#!/bin/sh

# The wifi_change event is used to trigger the check if the wifi is
# connected or not

if [ "$SENDER" = "wifi_change" ]; then
	CONNECTED="$(ifconfig en0 | awk '/status:/{print $2}')"

	if [ "$CONNECTED" = "active" ]; then
		ICON="󰖩"
	else
		ICON="󰖪"
	fi

	sketchybar --set "$NAME" icon="$ICON"
fi
