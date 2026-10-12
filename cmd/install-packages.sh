#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

function parsePackages() {
	local packagesFile="$1"
	local -n outRef="$2"

	if [[ -z "$packagesFile" || ! -f "$packagesFile" ]]; then
		printf "%b Package list file not found or not specified: '%s'\n" "$FORMAT_FAILURE" "$packagesFile" >&2
		return 1
	fi

	local line
	while IFS= read -r line || [[ -n "$line" ]]; do
		line="${line#"${line%%[![:space:]]*}"}"
		line="${line%"${line##*[![:space:]]}"}"
		[[ -z "$line" || "$line" =~ ^# ]] && continue
		outRef+=("$line")
	done < "$packagesFile"

	return 0
}


function installPackages() {
	local packagesFile="$1"
	local -a packages=()

	parsePackages "$packagesFile" packages || return 1

	if [[ ${#packages[@]} -eq 0 ]]; then
		printf "%b No packages found to install in '%s'.\n" "$FORMAT_WARNING" "$packagesFile"
		return 0
	fi

	local listName=$(basename "$packagesFile")
	printf "Installing %d packages from '%s'...\n" "${#packages[@]}" "$listName"

	if yay -S --needed --noconfirm "${packages[@]}"; then
		printf "%b Packages from '%s' installed successfully.\n" "$FORMAT_SUCCESS" "$listName"
		return 0
	fi

	printf "%b Batch package installation encountered errors. Installing individual packages...\n" "$FORMAT_WARNING"
	local -a failedPackages=()
	local pkg
	for pkg in "${packages[@]}"; do
		if ! yay -S --noconfirm "$pkg"; then
			printf "%b Failed to install package: '%s'\n" "$FORMAT_WARNING" "$pkg" >&2
			failedPackages+=("$pkg")
		fi
	done

	if [[ ${#failedPackages[@]} -gt 0 ]]; then
		printf "%b Failed to install %d package(s): %s\n" "$FORMAT_WARNING" "${#failedPackages[@]}" "${failedPackages[*]}" >&2
	else
		printf "%b All packages from '%s' installed successfully on retry pass.\n" "$FORMAT_SUCCESS" "$listName"
	fi

	return 0
}


function main() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s <PACKAGES_FILE>\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	local packagesFile="${1:-}"
	if [[ -z "$packagesFile" ]]; then
		printf "%b Packages file argument required.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	installPackages "$packagesFile"
}

main "$@"
