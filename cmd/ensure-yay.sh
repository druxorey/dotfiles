#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare TEMP_DIR=""

function cleanup() {
	if [[ -n $TEMP_DIR ]]; then
		rm -rf "$TEMP_DIR"
	fi

	return 0
}


function isCachyOs() {
	[[ -f /etc/os-release ]] || return 1
	[[ $(. /etc/os-release && printf '%s' "${ID:-}") == cachyos ]]
}


function buildAurPackage() {
	local -r packageName="$1"
	local -r buildDir="$TEMP_DIR/$packageName"

	printf "Cloning '%s' from AUR...\n" "$packageName"
	if ! git clone --quiet "https://aur.archlinux.org/$packageName.git" "$buildDir"; then
		printf "%b Failed to clone '%s' from AUR.\n" "$FORMAT_WARNING" "$packageName" >&2
		return 1
	fi

	printf "Building '%s'...\n" "$packageName"
	if ! (cd "$buildDir" && makepkg -si --noconfirm); then
		printf "%b Failed to build '%s'.\n" "$FORMAT_WARNING" "$packageName" >&2
		return 1
	fi

	return 0
}


function installYayFromAur() {
	printf "Installing yay AUR helper...\n"

	if ! sudo pacman -S --needed --noconfirm base-devel git; then
		printf "%b Failed to install base-devel and git.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	TEMP_DIR=$(mktemp -d) || return 1
	trap cleanup EXIT

	buildAurPackage "yay-bin" && return 0

	printf "Falling back to compiling yay from source...\n"
	buildAurPackage "yay" && return 0

	return 1
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

	if command -v yay >/dev/null 2>&1; then
		return 0
	fi

	if isCachyOs; then
		printf "Installing yay via pacman on CachyOS...\n"
		if sudo pacman -S --needed --noconfirm yay; then
			printf "%b yay installed successfully.\n" "$FORMAT_SUCCESS"
			return 0
		fi
		printf "%b Failed to install yay via pacman on CachyOS. Attempting fallback...\n" "$FORMAT_WARNING" >&2
	fi

	if ! installYayFromAur; then
		printf "%b Failed to install yay.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	if ! command -v yay >/dev/null 2>&1; then
		printf "%b yay installation could not be verified.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	printf "%b yay installed successfully.\n" "$FORMAT_SUCCESS"
	return 0
}

main "$@"
