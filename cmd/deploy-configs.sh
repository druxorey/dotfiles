#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

function deployDirectory() {
	local -r sourcePath="$1"
	local -r targetPath="$2"
	local -r label="$3"

	[[ -d $sourcePath ]] || return 0

	if ! mkdir -p "$targetPath" || ! cp -rf "$sourcePath/." "$targetPath/"; then
		printf "%b Failed to deploy %s to %s\n" "$FORMAT_FAILURE" "$label" "$targetPath" >&2
		return 1
	fi

	printf "%b Deployed %s to %s\n" "$FORMAT_SUCCESS" "$label" "$targetPath"
	return 0
}

function deployUserFiles() {
	local -r sourceDir="$1"

	deployDirectory "$sourceDir/config" "$HOME/.config" "configs" || return 1
	deployDirectory "$sourceDir/home" "$HOME" "home dotfiles" || return 1
	deployDirectory "$sourceDir/local" "$HOME/.local" "local data" || return 1

	return 0
}

function installCrontab() {
	local -r cronDir="$1"
	local cronFile=""
	local candidate

	for candidate in "$cronDir"/*; do
		if [[ -f $candidate ]]; then
			cronFile="$candidate"
			break
		fi
	done

	[[ -z $cronFile ]] && return 0

	printf "Installing crontab from '%s'...\n" "${cronFile##*/}"

	if ! command -v crontab >/dev/null 2>&1; then
		printf "%b The 'crontab' command was not found, skipping crontab installation.\n" "$FORMAT_WARNING" >&2
		return 0
	fi

	if crontab "$cronFile" 2>/dev/null; then
		printf "%b Crontab configured.\n" "$FORMAT_SUCCESS"
		return 0
	fi

	# Fallback: write the crontab straight into the spool, owned by the user
	local -r currentUser="${USER:-$(id -un)}"
	local -r spoolFile="/var/spool/cron/$currentUser"
	if sudo mkdir -p /var/spool/cron \
		&& sudo cp "$cronFile" "$spoolFile" \
		&& sudo chown "$currentUser" "$spoolFile" \
		&& sudo chmod 600 "$spoolFile"; then
		printf "%b Crontab configured (spool fallback).\n" "$FORMAT_SUCCESS"
		return 0
	fi

	printf "%b Failed to install crontab from '%s'.\n" "$FORMAT_FAILURE" "${cronFile##*/}" >&2
	return 1
}

function deploySystemExtras() {
	local -r sourceDir="$1"

	if [[ -d $sourceDir/extras/etc ]]; then
		printf "Deploying system extras to /etc...\n"
		if ! sudo cp -rf "$sourceDir/extras/etc/." "/etc/"; then
			printf "%b Failed to deploy extras to /etc\n" "$FORMAT_FAILURE" >&2
			return 1
		fi
		printf "%b Deployed extras to /etc\n" "$FORMAT_SUCCESS"
	fi

	if [[ -d $sourceDir/extras/var/spool/cron ]]; then
		installCrontab "$sourceDir/extras/var/spool/cron" || return 1
	fi

	return 0
}

function deployConfigs() {
	local sourceDir="$1"

	if [[ -z $sourceDir || ! -d $sourceDir ]]; then
		printf "%b Source directory not found: '%s'\n" "$FORMAT_FAILURE" "$sourceDir" >&2
		return 1
	fi

	sourceDir="${sourceDir%/}"
	printf "Deploying configurations for '%s'...\n" "${sourceDir##*/}"

	deployUserFiles "$sourceDir" || return 1
	deploySystemExtras "$sourceDir" || return 1

	return 0
}

function main() {
	local opt

	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s <SOURCE_DIR> [MORE_SOURCE_DIRS...]\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	if (($# == 0)); then
		printf "%b At least one source directory argument is required.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	local dir
	for dir in "$@"; do
		deployConfigs "$dir" || return 1
	done

	return 0
}

main "$@"
