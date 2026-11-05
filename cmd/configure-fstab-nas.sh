#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r FSTAB_FILE="/etc/fstab"
declare -r MOUNT_ROOT="/mnt"
declare -r CREDENTIALS_PREFIX="/etc/nss-credentials-"

function help() {
	local -r HELP_BOLD="\e[1;34m"
	local -r HELP_RESET="\e[0m"

	echo -e "${HELP_BOLD}USAGE:${HELP_RESET} NAS_PASSWORD=<PASSWORD> ${0##*/} -n NAME -s //SERVER/SHARE -u USER

${HELP_BOLD}DESCRIPTION:${HELP_RESET} Configures an SMB/CIFS share to be mounted at /mnt/NAME on demand.
It installs cifs-utils if needed, stores the credentials in a root-only file and appends the
entry to /etc/fstab without touching the existing content. Running it again for the same
name refreshes the credentials and leaves fstab as it is.

${HELP_BOLD}OPTIONS:${HELP_RESET}
  -n NAME              Mount point name (the share is mounted at /mnt/NAME).
  -s //SERVER/SHARE    SMB share address.
  -u USER              SMB username.
  -h                   Display this help message.

${HELP_BOLD}ENVIRONMENT:${HELP_RESET}
  NAS_PASSWORD         SMB password (read from the environment so it never shows up in the process list)."
	exit 0
}

function validateArguments() {
	local -r name="$1"
	local -r server="$2"
	local -r user="$3"

	if [[ ! $name =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
		printf "%b Invalid mount point name: '%s' (use letters, numbers, dots, dashes and underscores).\n" "$FORMAT_FAILURE" "$name" >&2
		return 1
	fi

	if [[ ! $server =~ ^//[^/[:space:]]+/[^[:space:]]+$ ]]; then
		printf "%b Invalid share address: '%s' (use the format //SERVER/SHARE, without spaces).\n" "$FORMAT_FAILURE" "$server" >&2
		return 1
	fi

	if [[ ! $user =~ ^[^[:space:]]+$ ]]; then
		printf "%b The username cannot be empty or contain spaces.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	if [[ -z ${NAS_PASSWORD:-} || $NAS_PASSWORD == *$'\n'* ]]; then
		printf "%b NAS_PASSWORD must be set in the environment and cannot contain line breaks.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	return 0
}

function installDependencies() {
	if pacman -Qi cifs-utils >/dev/null 2>&1; then
		return 0
	fi

	printf "Installing cifs-utils...\n"
	if ! sudo pacman -S --needed --noconfirm cifs-utils; then
		printf "%b Failed to install cifs-utils.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	return 0
}

function writeCredentials() {
	local -r credentialsFile="$1"
	local -r user="$2"

	# Create the file empty and root-only first, so the password is never readable by others
	if ! sudo install -m 600 /dev/null "$credentialsFile" \
		|| ! printf 'username=%s\npassword=%s\n' "$user" "$NAS_PASSWORD" | sudo tee "$credentialsFile" >/dev/null; then
		printf "%b Failed to write credentials to '%s'.\n" "$FORMAT_FAILURE" "$credentialsFile" >&2
		return 1
	fi

	return 0
}

function hasFstabEntry() {
	local -r mountPoint="$1"
	local device target rest

	while read -r device target rest || [[ -n $device ]]; do
		[[ -z $device || $device == \#* ]] && continue
		if [[ $target == "$mountPoint" ]]; then
			return 0
		fi
	done < "$FSTAB_FILE"

	return 1
}

function addFstabEntry() {
	local -r entry="$1"
	local -r backupFile="$FSTAB_FILE.drxdots.bak"
	local lineBreak=""

	# Keep the very first version of fstab as a safety net
	if [[ ! -e $backupFile ]] && ! sudo cp "$FSTAB_FILE" "$backupFile"; then
		printf "%b Failed to back up %s.\n" "$FORMAT_FAILURE" "$FSTAB_FILE" >&2
		return 1
	fi

	# If the file does not end with a newline, appending would glue the entry to the last line
	if [[ -s $FSTAB_FILE && -n $(tail -c1 "$FSTAB_FILE") ]]; then
		lineBreak=$'\n'
	fi

	if ! printf '%s%s\n' "$lineBreak" "$entry" | sudo tee -a "$FSTAB_FILE" >/dev/null; then
		printf "%b Failed to append the entry to %s.\n" "$FORMAT_FAILURE" "$FSTAB_FILE" >&2
		return 1
	fi

	return 0
}

function configureShare() {
	local -r name="$1"
	local -r server="$2"
	local -r user="$3"
	local -r mountPoint="$MOUNT_ROOT/$name"
	local -r credentialsFile="$CREDENTIALS_PREFIX$name.smb"

	printf "Configuring NAS share '%s' (%s)...\n" "$name" "$server"

	installDependencies || return 1

	if ! sudo mkdir -p "$mountPoint"; then
		printf "%b Failed to create '%s'.\n" "$FORMAT_FAILURE" "$mountPoint" >&2
		return 1
	fi

	writeCredentials "$credentialsFile" "$user" || return 1

	if hasFstabEntry "$mountPoint"; then
		printf "%b %s already has an entry in %s, leaving it untouched.\n" "$FORMAT_WARNING" "$mountPoint" "$FSTAB_FILE"
		return 0
	fi

	local -r entry="$server $mountPoint cifs credentials=$credentialsFile,iocharset=utf8,nofail,_netdev,x-systemd.automount 0 0"
	addFstabEntry "$entry" || return 1

	if ! sudo systemctl daemon-reload; then
		printf "%b Could not reload systemd, the new mount will be picked up after a reboot.\n" "$FORMAT_WARNING" >&2
	fi

	printf "%b NAS share '%s' will be mounted at %s on first access.\n" "$FORMAT_SUCCESS" "$name" "$mountPoint"
	return 0
}

function main() {
	local opt
	local name=""
	local server=""
	local user=""

	while getopts "hn:s:u:" opt; do
		case $opt in
			h) help ;;
			n) name="$OPTARG" ;;
			s) server="$OPTARG" ;;
			u) user="$OPTARG" ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	if (($# > 0)); then
		printf "%b Unexpected argument: '%s'. Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "$1" "${0##*/}" >&2
		return 1
	fi

	validateArguments "$name" "$server" "$user" || return 1
	configureShare "$name" "$server" "$user"
}

main "$@"
