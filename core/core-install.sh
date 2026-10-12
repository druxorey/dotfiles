#!/usr/bin/env bash

declare -r FORMAT_SUCCESS="\e[1;32m[SUCCESS]\e[0m"
declare -r FORMAT_WARNING="\e[1;33m[WARNING]\e[0m"
declare -r FORMAT_FAILURE="\e[1;31m[FAILURE]\e[0m"

declare -r SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -r REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

function setupZsh() {
	printf "Configuring ZSH environment...\n"

	# Create /etc/zsh/zshenv with ZDOTDIR export
	if [[ ! -f "/etc/zsh/zshenv" ]] || ! grep -q 'ZDOTDIR=' "/etc/zsh/zshenv" 2>/dev/null; then
		printf "Setting up /etc/zsh/zshenv...\n"
		sudo mkdir -p /etc/zsh
		echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee /etc/zsh/zshenv >/dev/null
		printf "%b Configured /etc/zsh/zshenv\n" "$FORMAT_SUCCESS"
	fi

	# Setup ZSH plugins
	local -r zshPluginsDir="$HOME/.config/zsh"
	mkdir -p "$zshPluginsDir"

	local -A plugins=(
		["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
		["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
		["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
	)

	local pluginName
	for pluginName in "${!plugins[@]}"; do
		local pluginTarget="$zshPluginsDir/$pluginName"
		if [[ ! -d "$pluginTarget" ]]; then
			printf "Cloning ZSH plugin '%s'...\n" "$pluginName"
			git clone "${plugins[$pluginName]}" "$pluginTarget" >/dev/null 2>&1 || {
				printf "%b Failed to clone ZSH plugin '%s'.\n" "$FORMAT_WARNING" "$pluginName" >&2
			}
		fi
	done

	# Ensure secrets.zsh exists so .zshrc does not complain
	local -r secretsFile="$zshPluginsDir/secrets.zsh"
	if [[ ! -f "$secretsFile" ]]; then
		touch "$secretsFile"
		chmod 600 "$secretsFile"
	fi

	# Change default shell to zsh if available
	if command -v zsh >/dev/null 2>&1; then
		local zshPath=$(which zsh)
		if [[ "$SHELL" != "$zshPath" ]]; then
			printf "Setting %s as default shell...\n" "$zshPath"
			sudo chsh -s "$zshPath" "$USER" 2>/dev/null || chsh -s "$zshPath" 2>/dev/null || true
		fi
	fi

	return 0
}


function deployUtils() {
	if [[ -d "$REPO_DIR/utils" ]]; then
		mkdir -p "$HOME/.local/bin"
		cp -rf "$REPO_DIR/utils/." "$HOME/.local/bin/"
		chmod +x "$HOME/.local/bin/"* 2>/dev/null || true
		printf "%b Deployed utility scripts to %s/.local/bin\n" "$FORMAT_SUCCESS" "$HOME"
	fi
	return 0
}


function main() {
	while getopts "h" opt; do
		case $opt in
			h) printf "\e[1;34mUSAGE:\e[0m %s\n" "${0##*/}" && return 0 ;;
			*) printf "%b Try '%s -h' for more information.\n" "$FORMAT_FAILURE" "${0##*/}" >&2 && return 1 ;;
		esac
	done
	shift $((OPTIND - 1))

	printf "Starting Core Installation...\n"

	"$REPO_DIR/cmd/ensure-sudo.sh" || return 1
	"$REPO_DIR/cmd/install-yay.sh" || return 1
	"$REPO_DIR/cmd/install-packages.sh" "$SCRIPT_DIR/core.packages" || return 1
	"$REPO_DIR/cmd/deploy-configs.sh" "$SCRIPT_DIR" || return 1
	deployUtils || return 1
	setupZsh || return 1
	"$REPO_DIR/cmd/enable-services.sh" "$SCRIPT_DIR/core.services" || return 1

	printf "%b Core installation completed successfully.\n" "$FORMAT_SUCCESS"
	return 0
}

main "$@"
