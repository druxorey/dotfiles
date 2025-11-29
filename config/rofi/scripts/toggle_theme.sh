#!/bin/bash

CACHE_FILE=~/.cache/actual_theme

declare -A APP_ROUTES

APP_ROUTES[polybar]="/home/druxorey/.config/polybar"
APP_ROUTES[kitty]="/home/druxorey/.config/kitty"
APP_ROUTES[rofi]="/home/druxorey/.config/rofi/shared"

declare -A APP_FILE

APP_FILE[polybar]="theme.ini"
APP_FILE[kitty]="kitty.conf"
APP_FILE[rofi]="theme_colorscheme.rasi"

function toggleMode() {
	mode=$1

	for app in "${!APP_ROUTES[@]}"; do
		config_path="${APP_ROUTES[$app]}"
		config_file="${APP_FILE[$app]}"

		rm -f "$config_path/$config_file"
		cp "$config_path/${config_file%.*}_${mode}.${config_file##*.}" "$config_path/$config_file"
	done
}


function main() {
	if [[ ! -f $CACHE_FILE ]]; then
		touch $CACHE_FILE
	fi

	mode=$(<$CACHE_FILE)

	if [[ $mode == "dark" ]]; then
		toggleMode "light"
		notify-send -u low "Cambiado a modo claro"
		echo "light" > $CACHE_FILE
	else
		toggleMode "dark"
		notify-send -u low "Cambiado a modo oscuro"
		echo "dark" > $CACHE_FILE
	fi

	pkill -USR1 polybar
}

main "$@"
