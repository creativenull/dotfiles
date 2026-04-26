#!/bin/sh

# Reload sketchybar when the theme changes to apply light/dark theme.
# This script is triggered by the AppleInterfaceThemeChangedNotification event.

if [ "$SENDER" = "theme_change" ] || [ "$SENDER" = "system_woke" ]; then
  # Get the new theme
  NEW_THEME=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")

  # Source the colors file
  source "$CONFIG_DIR/colors.sh"

  # Set theme colors based on new theme
  if [ "$NEW_THEME" = "Dark" ]; then
    BG_COLOR=$DARK_BG_COLOR
    TEXT_COLOR=$DARK_TEXT_COLOR
    HIGHLIGHT_COLOR=$DARK_HIGHLIGHT_COLOR
    BORDER_COLOR=$DARK_BORDER_COLOR
    BORDER_WIDTH=$DARK_BORDER_WIDTH
	CLOCK_BORDER_COLOR=$DARK_CLOCK_BORDER_COLOR
    CLOCK_BORDER_WIDTH=$DARK_CLOCK_BORDER_WIDTH
    SPACE_TEXT_COLOR=$DARK_SPACE_TEXT_COLOR
    SPACE_BG_COLOR=$DARK_SPACE_BG_COLOR
    SPACE_TEXT_HIGHLIGHT_COLOR=$DARK_SPACE_TEXT_HIGHLIGHT_COLOR
    SPACE_BG_HIGHLIGHT_COLOR=$DARK_SPACE_BG_HIGHLIGHT_COLOR
    CLOCK_BG_COLOR=$DARK_CLOCK_BG_COLOR
    CLOCK_TEXT_COLOR=$DARK_CLOCK_TEXT_COLOR
    ITEM_ICON_COLOR=$DARK_ITEM_ICON_COLOR
    ITEM_LABEL_COLOR=$DARK_ITEM_LABEL_COLOR
  else
    BG_COLOR=$LIGHT_BG_COLOR
    TEXT_COLOR=$LIGHT_TEXT_COLOR
    HIGHLIGHT_COLOR=$LIGHT_HIGHLIGHT_COLOR
    BORDER_COLOR=$LIGHT_BORDER_COLOR
    BORDER_WIDTH=$LIGHT_BORDER_WIDTH
    CLOCK_BORDER_COLOR=$LIGHT_CLOCK_BORDER_COLOR
    CLOCK_BORDER_WIDTH=$LIGHT_CLOCK_BORDER_WIDTH
    SPACE_TEXT_COLOR=$LIGHT_SPACE_TEXT_COLOR
    SPACE_BG_COLOR=$LIGHT_SPACE_BG_COLOR
    SPACE_TEXT_HIGHLIGHT_COLOR=$LIGHT_SPACE_TEXT_HIGHLIGHT_COLOR
    SPACE_BG_HIGHLIGHT_COLOR=$LIGHT_SPACE_BG_HIGHLIGHT_COLOR
    CLOCK_BG_COLOR=$LIGHT_CLOCK_BG_COLOR
    CLOCK_TEXT_COLOR=$LIGHT_CLOCK_TEXT_COLOR
    ITEM_ICON_COLOR=$LIGHT_ITEM_ICON_COLOR
    ITEM_LABEL_COLOR=$LIGHT_ITEM_LABEL_COLOR
  fi

  # Update colors dynamically without full reload to prevent flashing
  sketchybar --set front_app label.color="$TEXT_COLOR" background.color="$BG_COLOR" \
    --set clock label.color="$CLOCK_TEXT_COLOR" background.color="$CLOCK_BG_COLOR" background.border_color="$CLOCK_BORDER_COLOR" background.border_width="$CLOCK_BORDER_WIDTH" \
    --set battery icon.color="$ITEM_ICON_COLOR" label.color="$ITEM_LABEL_COLOR" background.color="$BG_COLOR" \
    --set volume icon.color="$ITEM_ICON_COLOR" label.color="$ITEM_LABEL_COLOR" background.color="$BG_COLOR" \
    --set wifi icon.color="$ITEM_ICON_COLOR" background.color="$BG_COLOR" \
    --set bluetooth_headset icon.color="$ITEM_ICON_COLOR" background.color="$BG_COLOR" \
    --set spaces background.color="$SPACE_BG_COLOR" background.border_color="$BORDER_COLOR" background.border_width="$BORDER_WIDTH" \
    --set '/space\..*/' icon.color="$SPACE_TEXT_COLOR" icon.highlight_color="$SPACE_TEXT_HIGHLIGHT_COLOR" background.color="$SPACE_BG_HIGHLIGHT_COLOR"

  # Force space scripts to run to update the selected/non-selected drawing state
  # This will properly set which space gets the highlight background shown
  sketchybar --trigger space_change
fi
