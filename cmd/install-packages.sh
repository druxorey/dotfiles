#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

function parsePackages() {
	local -r packagesFile="$1"
	local -n outRef="$2"

	if [[ -z $packagesFile || ! -f $packagesFile ]]; then
		printf "%b Package list file not found or not specified: '%s'\n" "$FORMAT_FAILURE" "$packagesFile" >&2
		return 1
	fi

	local line
	while IFS= read -r line || [[ -n $line ]]; do
		line="${line#"${line%%[![:space:]]*}"}"
		line="${line%"${line##*[![:space:]]}"}"
		[[ -z $line || $line =~ ^# ]] && continue
		outRef+=("$line")
	done < "$packagesFile"

	return 0
}

function installPackages() {
	local -r packagesFile="$1"
	local -a packages=()

	parsePackages "$packagesFile" packages || return 1

	local -r listName="${packagesFile##*/}"

	if ((${#packages[@]} == 0)); then
		printf "%b No packages found to install in '%s'.\n" "$FORMAT_WARNING" "$listName"
		return 0
	fi

	printf "Installing %d packages from '%s'...\n" "${#packages[@]}" "$listName"

	if yay -S --needed --noconfirm "${packages[@]}"; then
		printf "%b Packages from '%s' installed successfully.\n" "$FORMAT_SUCCESS" "$listName"
		return 0
	fi

	printf "%b Batch package installation encountered errors. Installing individual packages...\n" "$FORMAT_WARNING" >&2
	local -a failedPackages=()
	local package
	for package in "${packages[@]}"; do
		if ! yay -S --needed --noconfirm "$package"; then
			printf "%b Failed to install package: '%s'\n" "$FORMAT_WARNING" "$package" >&2
			failedPackages+=("$package")
		fi
	done

	if ((${#failedPackages[@]} > 0)); then
		printf "%b Failed to install %d package(s): %s\n" "$FORMAT_WARNING" "${#failedPackages[@]}" "${failedPackages[*]}" >&2
	else
		printf "%b All packages from '%s' installed successfully on retry pass.\n" "$FORMAT_SUCCESS" "$listName"
	fi

	return 0
}

function main() {
	local opt

	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s <PACKAGES_FILE> [MORE_PACKAGES_FILES...]\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	if (($# == 0)); then
		printf "%b At least one packages file argument is required.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	if ! command -v yay >/dev/null 2>&1; then
		printf "%b 'yay' is required but not installed. Run ensure-yay.sh first.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	local file
	for file in "$@"; do
		installPackages "$file" || return 1
	done

	return 0
}

main "$@"
