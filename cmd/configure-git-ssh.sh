#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r GITCONFIG_FILE="$HOME/.gitconfig"
declare -r SSH_DIR="$HOME/.ssh"
declare -r SSH_KEY_FILE="$SSH_DIR/id_ed25519"

function help() {
	local -r HELP_BOLD="\e[1;34m"
	local -r HELP_RESET="\e[0m"

	echo -e "${HELP_BOLD}USAGE:${HELP_RESET} ${0##*/} -n NAME -e EMAIL [-k SIGNING_KEY] [-s]

${HELP_BOLD}DESCRIPTION:${HELP_RESET} Sets your Git identity in the already deployed ~/.gitconfig (user.name,
user.email and, optionally, user.signingkey) and can generate an ed25519 SSH key. An existing
SSH key is never overwritten. Running it again simply updates the identity.

${HELP_BOLD}OPTIONS:${HELP_RESET}
  -n NAME           Git user name.
  -e EMAIL          Git email (also used as the SSH key comment).
  -k SIGNING_KEY    Signing key ID (optional).
  -s                Generate ~/.ssh/id_ed25519 (without passphrase) if it does not exist.
  -h                Display this help message."
	exit 0
}

function validateArguments() {
	local -r name="$1"
	local -r email="$2"
	local -r signingKey="$3"

	if [[ ! $name =~ ^[^[:space:]] || $name == *$'\n'* ]]; then
		printf "%b The name is required and cannot start with a space or contain line breaks.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	if [[ ! $email =~ ^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$ ]]; then
		printf "%b Invalid email address: '%s'\n" "$FORMAT_FAILURE" "$email" >&2
		return 1
	fi

	if [[ ! $signingKey =~ ^[A-Za-z0-9]*$ ]]; then
		printf "%b Invalid signing key ID: '%s' (letters and numbers only).\n" "$FORMAT_FAILURE" "$signingKey" >&2
		return 1
	fi

	return 0
}

function configureIdentity() {
	local -r name="$1"
	local -r email="$2"
	local -r signingKey="$3"

	if [[ ! -f $GITCONFIG_FILE ]]; then
		printf "%b '%s' not found. Install the core flavour first so the dotfiles are deployed.\n" "$FORMAT_FAILURE" "$GITCONFIG_FILE" >&2
		return 1
	fi

	if ! git config --file "$GITCONFIG_FILE" user.name "$name" \
		|| ! git config --file "$GITCONFIG_FILE" user.email "$email"; then
		printf "%b Failed to write the identity to %s.\n" "$FORMAT_FAILURE" "$GITCONFIG_FILE" >&2
		return 1
	fi

	if [[ -n $signingKey ]]; then
		if ! git config --file "$GITCONFIG_FILE" user.signingkey "$signingKey"; then
			printf "%b Failed to write the signing key to %s.\n" "$FORMAT_FAILURE" "$GITCONFIG_FILE" >&2
			return 1
		fi
	elif grep -qF 'SIGNING_KEY' "$GITCONFIG_FILE"; then
		printf "%b %s still contains the SIGNING_KEY placeholder: signed commits will fail until you set user.signingkey (or disable commit.gpgsign).\n" "$FORMAT_WARNING" "$GITCONFIG_FILE" >&2
	fi

	printf "%b Git identity configured: %s <%s>\n" "$FORMAT_SUCCESS" "$name" "$email"
	return 0
}

function ensureSshKeygen() {
	if command -v ssh-keygen >/dev/null 2>&1; then
		return 0
	fi

	printf "Installing openssh...\n"
	if ! sudo pacman -S --needed --noconfirm openssh || ! command -v ssh-keygen >/dev/null 2>&1; then
		printf "%b Failed to install openssh.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	return 0
}

function setupSshKey() {
	local -r email="$1"
	local -r publicKeyFile="$SSH_KEY_FILE.pub"

	ensureSshKeygen || return 1

	if ! mkdir -p "$SSH_DIR" || ! chmod 700 "$SSH_DIR"; then
		printf "%b Failed to prepare '%s'.\n" "$FORMAT_FAILURE" "$SSH_DIR" >&2
		return 1
	fi

	if [[ -e $SSH_KEY_FILE ]]; then
		printf "An SSH key already exists at %s, leaving it untouched.\n" "$SSH_KEY_FILE"
	else
		if ! ssh-keygen -q -t ed25519 -C "$email" -f "$SSH_KEY_FILE" -N ""; then
			printf "%b Failed to generate the SSH key.\n" "$FORMAT_FAILURE" >&2
			return 1
		fi
		printf "%b SSH key generated at %s (no passphrase, add one with 'ssh-keygen -p -f %s').\n" "$FORMAT_SUCCESS" "$SSH_KEY_FILE" "$SSH_KEY_FILE"
	fi

	if [[ ! -f $publicKeyFile ]]; then
		printf "%b Public key not found at %s.\n" "$FORMAT_WARNING" "$publicKeyFile" >&2
		return 0
	fi

	printf "Add this public key to your GitHub account (https://github.com/settings/keys):\n"
	cat "$publicKeyFile"

	return 0
}

function main() {
	local opt
	local name=""
	local email=""
	local signingKey=""
	local -i generateKey=0

	while getopts "hn:e:k:s" opt; do
		case $opt in
			h) help ;;
			n) name="$OPTARG" ;;
			e) email="$OPTARG" ;;
			k) signingKey="$OPTARG" ;;
			s) generateKey=1 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	if (($# > 0)); then
		printf "%b Unexpected argument: '%s'. Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "$1" "${0##*/}" >&2
		return 1
	fi

	validateArguments "$name" "$email" "$signingKey" || return 1

	if ! command -v git >/dev/null 2>&1; then
		printf "%b 'git' is required but not installed.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	configureIdentity "$name" "$email" "$signingKey" || return 1

	if ((generateKey)); then
		setupSshKey "$email" || return 1
	fi

	return 0
}

main "$@"
