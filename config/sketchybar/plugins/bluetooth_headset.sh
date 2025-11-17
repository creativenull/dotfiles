#!/bin/sh

# This is used to check if bluetooth is connected or not

if [ "$SENDER" = "bluetooth_change" ] || [ "$SENDER" = "system_woke" ]; then
	DEVICES="$(system_profiler SPBluetoothDataType -json -detailLevel basic 2>/dev/null | jq -rc '.SPBluetoothDataType[0].device_connected[] | select ( .[] | .device_minorType == "Headset")' | jq '.[]')"

	if [ "$DEVICES" = "" ]; then
		sketchybar --set "$NAME" drawing=off background.drawing=off
	else
		ICON="󰂯 "
		sketchybar --set "$NAME" icon="$ICON"
	fi
fi
