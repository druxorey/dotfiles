#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

function installYay() {
	if command -v yay >/dev/null 2>&1; then
		return 0
	fi

	printf "Installing yay AUR helper...\n"
	if ! sudo pacman -S --needed --noconfirm base-devel git; then
		printf "%b Failed to install base-devel and git.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	local tempDir=$(mktemp -d) || return 1
	trap 'rm -rf "$tempDir"' RETURN

	printf "Cloning yay-bin from AUR...\n"
	if git clone https://aur.archlinux.org/yay-bin.git "$tempDir/yay-bin" >/dev/null 2>&1; then
		(cd "$tempDir/yay-bin" && makepkg -si --noconfirm) || {
			printf "%b Failed to build yay-bin.\n" "$FORMAT_FAILURE" >&2
			return 1
		}
	else
		printf "Falling back to compiling yay from source...\n"
		if git clone https://aur.archlinux.org/yay.git "$tempDir/yay" >/dev/null 2>&1; then
			(cd "$tempDir/yay" && makepkg -si --noconfirm) || {
				printf "%b Failed to build yay.\n" "$FORMAT_FAILURE" >&2
				return 1
			}
		else
			printf "%b Failed to clone yay repository.\n" "$FORMAT_FAILURE" >&2
			return 1
		fi
	fi

	if ! command -v yay >/dev/null 2>&1; then
		printf "%b yay installation could not be verified.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	printf "%b yay installed successfully.\n" "$FORMAT_SUCCESS"
	return 0
}


function main() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done

	installYay
}

main "$@"
