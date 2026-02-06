#!/bin/bash

CACHE_FILE=~/.cache/actual_theme

declare -A APP_ROUTES

APP_ROUTES[polybar]="$HOME/.config/polybar"
APP_ROUTES[kitty]="$HOME/.config/kitty"
APP_ROUTES[rofi]="$HOME/.config/rofi/shared"
APP_ROUTES[bspwm]="$HOME/.config/bspwm"
APP_ROUTES[dunst]="$HOME/.config/dunst"
APP_ROUTES[oh-my-posh]="$HOME/.config/oh-my-posh/"
APP_ROUTES[nvim]="$HOME/.config/nvim/lua/plugins"

declare -A APP_FILE

APP_FILE[polybar]="theme.ini"
APP_FILE[kitty]="kitty.conf"
APP_FILE[rofi]="theme_colorscheme.rasi"
APP_FILE[bspwm]="bspwmrc"
APP_FILE[dunst]="dunstrc"
APP_FILE[oh-my-posh]="theme.omp.json"
APP_FILE[nvim]="colorscheme"

function toggleMode() {
	mode=$1

	for app in "${!APP_ROUTES[@]}"; do
		configPath="${APP_ROUTES[$app]}"
		configFile="${APP_FILE[$app]}"

		rm -f "$configPath/$configFile"
		if [[ "$app" == "nvim" ]]; then
			cp "$configPath/${configFile}_${mode}.bak" "$configPath/$configFile.lua"
		elif [[ "$configFile" == *.* ]]; then
			cp "$configPath/${configFile%.*}_${mode}.${configFile##*.}" "$configPath/$configFile"
		else
			cp "$configPath/${configFile}_${mode}" "$configPath/$configFile"
		fi
	done
}


function main() {
	if [[ ! -f $CACHE_FILE ]]; then
		touch $CACHE_FILE
	fi

	mode=$(<$CACHE_FILE)

	if [[ $mode == "dark" ]]; then
		toggleMode "light"
		mode="light"
		gsettings set org.gnome.desktop.interface color-scheme 'default'
		echo "light" > $CACHE_FILE
	else
		toggleMode "dark"
		mode="dark"
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
		echo "dark" > $CACHE_FILE
	fi

	bspc wm -r
	killall -USR1 kitty
	killall polybar; polybar &
	killall dunst; dunst &
	feh --bg-fill "$HOME/.local/share/wallpaper_$mode.png"
	notify-send -u low "Switched to $mode theme"
}

main "$@"
