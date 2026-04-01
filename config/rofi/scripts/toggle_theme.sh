#!/bin/bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_ERROR="\e[1;31m[ERROR]\e[0m"

declare -r CACHE_FILE=~/.cache/actual_theme
declare -r ACTUAL_WALLPAPER_PATH="$HOME/.local/share/wallpaper_actual.png"

declare -A APP_ROUTES

APP_ROUTES[polybar]="$HOME/.config/polybar"
APP_ROUTES[kitty]="$HOME/.config/kitty"
APP_ROUTES[rofi]="$HOME/.config/rofi/shared"
APP_ROUTES[bspwm]="$HOME/.config/bspwm"
APP_ROUTES[dunst]="$HOME/.config/dunst"
APP_ROUTES[oh-my-posh]="$HOME/.config/oh-my-posh/"
APP_ROUTES[nvim-theme]="$HOME/.config/nvim/lua/plugins"
APP_ROUTES[nvim-lualine]="$HOME/.config/nvim/lua/plugins"
APP_ROUTES[tmux]="$HOME/.config/tmux/plugins/tmux/scripts"
APP_ROUTES[zathura]="$HOME/.config/zathura"
APP_ROUTES[yazi]="$HOME/.config/yazi"

declare -A APP_FILE

APP_FILE[polybar]="theme.ini"
APP_FILE[kitty]="kitty.conf"
APP_FILE[rofi]="theme_colorscheme.rasi"
APP_FILE[bspwm]="bspwmrc"
APP_FILE[dunst]="dunstrc"
APP_FILE[oh-my-posh]="theme.omp.json"
APP_FILE[nvim-theme]="colorscheme"
APP_FILE[nvim-lualine]="lazy-lualine"
APP_FILE[tmux]="dracula.sh"
APP_FILE[zathura]="zathurarc"
APP_FILE[yazi]="theme.toml"

function toggleMode() {
	local mode=$1

	for app in "${!APP_ROUTES[@]}"; do
		local configPath="${APP_ROUTES[$app]}"
		local configFile="${APP_FILE[$app]}"

		printf "Updating %s at %s\n" "$app" "$configPath"
		rm -f "$configPath/$configFile"
		if [[ "$app" =~ ^nvim.* ]]; then
			cp "$configPath/${configFile}_${mode}.bak" "$configPath/$configFile.lua"
		elif [[ "$configFile" == *.* ]]; then
			cp "$configPath/${configFile%.*}_${mode}.${configFile##*.}" "$configPath/$configFile"
		else
			cp "$configPath/${configFile}_${mode}" "$configPath/$configFile"
		fi
	done
}


function main() {
	[[ ! -f $CACHE_FILE ]] && touch $CACHE_FILE

	local mode=$(<$CACHE_FILE)
	printf "Current mode detected: %s\n" "${mode:-none}"

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

	printf "Updating wallpaper link for %s mode\n" "$mode"

	if ln -sf "$HOME/.local/share/wallpaper_$mode.png" "$ACTUAL_WALLPAPER_PATH"; then
		printf "%b Wallpaper link updated.\n" "$FORMAT_SUCCESS"
	else
		printf "%b Failed to update wallpaper link.\n" "$FORMAT_ERROR"
	fi

	printf "Refreshing system components...\n"
	
	bspc wm -r
	killall -USR1 kitty
	killall dunst; dunst &
	killall polybar; polybar &

	notify-send "Switched to $mode theme" --app-name "Toggle Theme" -u low
	printf "Theme switch to %s completed.\n" "$mode"

	return 0
}

main "$@"
