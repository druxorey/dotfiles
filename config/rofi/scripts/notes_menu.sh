#!/bin/bash

ROFI_MENU_PATH='rofi -dmenu -p -i -config ~/.config/rofi/styles/notes_menu_styles.rasi'
DIRECTORY="/home/druxorey/Documents/01 Obsidian/D7 Cheatsheets"

if [ ! -d "$DIRECTORY" ]; then
	echo "El directorio $DIRECTORY no existe."
	exit 1
fi

FILE=$(find "$DIRECTORY" -type f -exec basename {} \; | $ROFI_MENU_PATH)

if [ -n "$FILE" ]; then
	kitty -e nvim "$DIRECTORY/$FILE"
fi
