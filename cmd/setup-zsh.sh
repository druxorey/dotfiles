#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r ZSHENV_FILE="/etc/zsh/zshenv"
declare -r ZSH_DIR="$HOME/.config/zsh"

function configureZdotdir() {
	if [[ -f $ZSHENV_FILE ]] && grep -q 'ZDOTDIR=' "$ZSHENV_FILE" 2>/dev/null; then
		return 0
	fi

	printf "Setting up %s...\n" "$ZSHENV_FILE"
	if ! sudo mkdir -p "${ZSHENV_FILE%/*}" \
		|| ! printf '%s\n' 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a "$ZSHENV_FILE" >/dev/null; then
		printf "%b Failed to configure %s\n" "$FORMAT_FAILURE" "$ZSHENV_FILE" >&2
		return 1
	fi

	printf "%b Configured %s\n" "$FORMAT_SUCCESS" "$ZSHENV_FILE"
	return 0
}

function installPlugins() {
	local -A plugins=(
		["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
		["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
		["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
	)

	local pluginName
	for pluginName in "${!plugins[@]}"; do
		[[ -d $ZSH_DIR/$pluginName ]] && continue

		printf "Cloning ZSH plugin '%s'...\n" "$pluginName"
		if ! git clone --quiet "${plugins[$pluginName]}" "$ZSH_DIR/$pluginName"; then
			printf "%b Failed to clone ZSH plugin '%s'.\n" "$FORMAT_WARNING" "$pluginName" >&2
		fi
	done

	return 0
}

function ensureSecretsFile() {
	local -r secretsFile="$ZSH_DIR/secrets.zsh"

	[[ -f $secretsFile ]] && return 0

	if ! touch "$secretsFile" || ! chmod 600 "$secretsFile"; then
		printf "%b Failed to create '%s'.\n" "$FORMAT_FAILURE" "$secretsFile" >&2
		return 1
	fi

	return 0
}

function setDefaultShell() {
	local zshPath

	zshPath=$(command -v zsh) || return 0

	local -r currentUser="${USER:-$(id -un)}"
	local currentShell
	IFS=: read -r _ _ _ _ _ _ currentShell < <(getent passwd "$currentUser")

	[[ $currentShell == "$zshPath" ]] && return 0

	printf "Setting %s as default shell...\n" "$zshPath"
	if sudo chsh -s "$zshPath" "$currentUser" 2>/dev/null || chsh -s "$zshPath" 2>/dev/null; then
		printf "%b Default shell set to %s\n" "$FORMAT_SUCCESS" "$zshPath"
	else
		printf "%b Could not change the default shell to %s.\n" "$FORMAT_WARNING" "$zshPath" >&2
	fi

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

	if ! command -v git >/dev/null 2>&1; then
		printf "%b 'git' is required to install the ZSH plugins.\n" "$FORMAT_FAILURE" >&2
		return 1
	fi

	printf "Configuring ZSH environment...\n"

	configureZdotdir || return 1

	if ! mkdir -p "$ZSH_DIR"; then
		printf "%b Failed to create '%s'.\n" "$FORMAT_FAILURE" "$ZSH_DIR" >&2
		return 1
	fi

	installPlugins
	ensureSecretsFile || return 1
	setDefaultShell

	printf "%b ZSH environment configured successfully.\n" "$FORMAT_SUCCESS"
	return 0
}

main "$@"
