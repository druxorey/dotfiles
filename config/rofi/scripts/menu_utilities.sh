#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"

declare -r ROFI_CONFIG="$HOME/.config/rofi/modules/menu_utilities.rasi"
declare -r SCRIPTS_PATH="$HOME/.config/rofi/scripts"
declare -r ROFIMOJI_SETS="nerd_font emojis math box_drawing arrows kaomoji fontawesome fileicons weathericons currency greek"

function main() {
	printf "Initializing utilities menu...\n"

	declare -a menuNames
	declare -a menuCommands

	menuNames[0]="󰗊   Translator"
	menuNames[1]="󰪚   Calculator"
	menuNames[2]="󰘎   Text Extraction"
	menuNames[3]="󰞅   Emoji Selector"
	menuNames[4]="󰖟   Search in Web"
	menuNames[5]="   App Launcher"

	menuCommands[0]="sh $SCRIPTS_PATH/panel_translate.sh"
	menuCommands[1]="rofi -show calc -modi calc -no-show-match -no-sort -calc-command \"echo -n '{result}' | xclip -selection clipboard\" -config ~/.config/rofi/shared/layout_find.rasi"
	menuCommands[2]="sh $SCRIPTS_PATH/toggle_text_extract.sh"
	menuCommands[3]="rofimoji -f $ROFIMOJI_SETS -a copy --max-recent 0 --selector-args='-config ~/.config/rofi/shared/layout_find.rasi'"
	menuCommands[4]="sh $SCRIPTS_PATH/panel_search.sh"
	menuCommands[5]="rofi -show drun -i -config ~/.config/rofi/modules/launcher_apps.rasi"

	local selectedIndex=$(printf "%s\n" "${menuNames[@]}" | rofi -dmenu -format i -m -1 -config $ROFI_CONFIG)

	if [[ -z "$selectedIndex" ]]; then
		printf "%b No option selected. Exiting.\n" "$FORMAT_WARNING"
		exit 0
	fi

	local selectedName="${menuNames[$selectedIndex]}"
	local selectedCommand="${menuCommands[$selectedIndex]}"

	printf "Option selected: %s\n" "$selectedName"
	printf "%b Executing command...\n" "$FORMAT_SUCCESS"

	eval "$selectedCommand"

	return 0
}

main "$@"
