#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r CACHYOS_REPO_URL="https://mirror.cachyos.org/cachyos-repo.tar.xz"
declare -r PACMAN_CONF="/etc/pacman.conf"

declare TEMP_DIR=""

function help() {
	local -r HELP_BOLD="\e[1;34m"
	local -r HELP_RESET="\e[0m"

	echo -e "${HELP_BOLD}USAGE:${HELP_RESET} ${0##*/}

${HELP_BOLD}DESCRIPTION:${HELP_RESET} Adds the CachyOS repositories to a vanilla Arch Linux install using the
official CachyOS script. It detects the CPU level (x86-64-v3, x86-64-v4 or znver4), installs the
CachyOS keyring and mirrorlists, replaces pacman with the CachyOS fork and backs up pacman.conf.
Run a full system update afterwards (pacman -Syu) to start using the new repositories.

${HELP_BOLD}OPTIONS:${HELP_RESET}
  -h         Display this help message."
	exit 0
}

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

function hasCachyRepos() {
	grep -q '^\[cachyos' "$PACMAN_CONF" 2>/dev/null
}

function downloadInstaller() {
	TEMP_DIR=$(mktemp -d) || return 1
	trap cleanup EXIT

	printf "Downloading the CachyOS repository installer...\n"
	if ! curl -fsSL "$CACHYOS_REPO_URL" -o "$TEMP_DIR/cachyos-repo.tar.xz"; then
		printf "%b Failed to download '%s'.\n" "$FORMAT_FAILURE" "$CACHYOS_REPO_URL" >&2
		return 1
	fi

	if ! tar xf "$TEMP_DIR/cachyos-repo.tar.xz" -C "$TEMP_DIR" || [[ ! -f $TEMP_DIR/cachyos-repo/cachyos-repo.sh ]]; then
		printf "%b The downloaded archive does not contain 'cachyos-repo/cachyos-repo.sh'.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	return 0
}

function main() {
	local opt

	while getopts "h" opt; do
		case $opt in
			h) help ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	if isCachyOs; then
		printf "CachyOS detected: the CachyOS repositories are already part of the system.\n"
		return 0
	fi

	if hasCachyRepos; then
		printf "The CachyOS repositories are already configured in %s.\n" "$PACMAN_CONF"
		return 0
	fi

	if [[ $(uname -m) != x86_64 ]]; then
		printf "%b The CachyOS repositories are only available for x86_64 systems.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	local tool
	for tool in curl tar; do
		if ! command -v "$tool" >/dev/null 2>&1; then
			printf "%b '%s' is required but not installed.\n" "$FORMAT_FAILURE" "$tool" >&2
			return 1
		fi
	done

	downloadInstaller || return 1

	# The official script is interactive (pacman may ask for confirmation) and runs as root
	printf "Running the official CachyOS repository script...\n"
	if ! (cd "$TEMP_DIR/cachyos-repo" && sudo ./cachyos-repo.sh); then
		printf "%b The CachyOS repository script failed.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	if ! hasCachyRepos; then
		printf "%b The script finished but no CachyOS repository was added to %s (the CPU may not support x86-64-v3).\n" "$FORMAT_FAILURE" "$PACMAN_CONF" >&2
		return 1
	fi

	printf "%b CachyOS repositories added. Run a full system update (pacman -Syu) to start using them.\n" "$FORMAT_SUCCESS"
	return 0
}

main "$@"
