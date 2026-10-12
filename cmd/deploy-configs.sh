#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

function deployUserFiles() {
	local sourceDir="$1"

	# 1. Config directory -> ~/.config
	if [[ -d "$sourceDir/config" ]]; then
		mkdir -p "$HOME/.config"
		cp -rf "$sourceDir/config/." "$HOME/.config/"
		printf "%b Deployed configs to %s/.config\n" "$FORMAT_SUCCESS" "$HOME"
	fi

	# 2. Home directory -> ~/
	if [[ -d "$sourceDir/home" ]]; then
		mkdir -p "$HOME"
		cp -rf "$sourceDir/home/." "$HOME/"
		printf "%b Deployed home dotfiles to %s\n" "$FORMAT_SUCCESS" "$HOME"
	fi

	# 3. Local directory -> ~/.local
	if [[ -d "$sourceDir/local" ]]; then
		mkdir -p "$HOME/.local"
		cp -rf "$sourceDir/local/." "$HOME/.local/"
		printf "%b Deployed local data to %s/.local\n" "$FORMAT_SUCCESS" "$HOME"
	fi

	return 0
}


function deploySystemExtras() {
	local sourceDir="$1"

	# System extras -> /etc
	if [[ -d "$sourceDir/extras/etc" ]]; then
		printf "Deploying system extras to /etc...\n"
		sudo cp -rf "$sourceDir/extras/etc/." "/etc/"
		printf "%b Deployed extras to /etc\n" "$FORMAT_SUCCESS"
	fi

	# User crontab from extras
	if [[ -d "$sourceDir/extras/var/spool/cron" ]]; then
		local cronFile
		for cronFile in "$sourceDir/extras/var/spool/cron/"*; do
			if [[ -f "$cronFile" ]]; then
				printf "Installing crontab from '%s'...\n" "$(basename "$cronFile")"
				if command -v crontab >/dev/null 2>&1; then
					crontab "$cronFile" 2>/dev/null || {
						sudo mkdir -p /var/spool/cron
						sudo cp "$cronFile" "/var/spool/cron/$USER"
						sudo chmod 600 "/var/spool/cron/$USER"
					}
					printf "%b Crontab configured.\n" "$FORMAT_SUCCESS"
				fi
				break
			fi
		done
	fi

	return 0
}


function deployConfigs() {
	local sourceDir="$1"
	if [[ -z "$sourceDir" || ! -d "$sourceDir" ]]; then
		printf "%b Source directory not found: '%s'\n" "$FORMAT_FAILURE" "$sourceDir" >&2
		return 1
	fi

	local sourceName=$(basename "$sourceDir")
	printf "Deploying configurations for '%s'...\n" "$sourceName"

	deployUserFiles "$sourceDir" || return 1
	deploySystemExtras "$sourceDir" || return 1

	return 0
}


function main() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s <SOURCE_DIR>\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	local sourceDir="${1:-}"
	if [[ -z "$sourceDir" ]]; then
		printf "%b Source directory argument required.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	deployConfigs "$sourceDir"
}

main "$@"
