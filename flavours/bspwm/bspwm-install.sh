#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -r REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
declare -r FLAVOUR_NAME="${SCRIPT_DIR##*/}"

function setupPermissions() {
	printf "Configuring bspwm script permissions...\n"

	local target
	for target in \
		"$HOME/.config/bspwm/bspwmrc"* \
		"$HOME/.config/sxhkd/sxhkdrc"* \
		"$HOME/.config/autorandr/preswitch" \
		"$HOME/.config/autorandr/postswitch" \
		"$HOME/.config/rofi/utilities/get_shortcuts.py"; do
		if [[ -f $target ]]; then
			chmod +x "$target" || return 1
		fi
	done

	local -a scriptDirs=()
	local scriptDir
	for scriptDir in "$HOME/.config/polybar/scripts" "$HOME/.config/rofi/scripts" "$HOME/.config/dunst/scripts"; do
		if [[ -d $scriptDir ]]; then
			scriptDirs+=("$scriptDir")
		fi
	done

	if ((${#scriptDirs[@]} > 0)); then
		find "${scriptDirs[@]}" -type f -name "*.sh" -exec chmod +x {} + || return 1
	fi

	printf "%b Configured bspwm script permissions\n" "$FORMAT_SUCCESS"
	return 0
}

function main() {
	local opt

	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	printf "Installing '%s'...\n" "$FLAVOUR_NAME"
	bash "$REPO_DIR/cmd/install-packages.sh" "$SCRIPT_DIR/$FLAVOUR_NAME.packages" || return 1
	bash "$REPO_DIR/cmd/deploy-configs.sh" "$SCRIPT_DIR" || return 1
	setupPermissions || return 1
	bash "$REPO_DIR/cmd/enable-services.sh" "$SCRIPT_DIR/$FLAVOUR_NAME.services" || return 1

	printf "%b '%s' installation completed.\n" "$FORMAT_SUCCESS" "$FLAVOUR_NAME"
	return 0
}

main "$@"
