#!/bin/bash

TITLE="\e[1;35m"
RUNNING="\e[35m"
QUESTION="\e[36m"
SUCCESS="\e[1;32m"
FAILED="\e[1;31m"
END="\e[0m"
LINE="\n"

isAutomated=0

function help() {
	echo
	echo "USAGE: arch-bootstrap [OPTION]"
	echo
	echo "DESCRIPTION: The arch-bootstrap script automates the initial installation and configuration"
	echo "        of an Arch Linux system. It updates the system, installs essential packages"
	echo "        (both from Pacman and AUR), and enables necessary services like the firewall"
	echo "        and the login manager. It’s particularly useful for users who want a quick and"
	echo "        straightforward installation process."
	echo
	echo "OPTIONS:"
	echo "  -h    Shows this help."
	echo "  -a    Automated mode. The script will not ask for user confirmation."
	echo
	echo "Report bugs to https://github.com/druxorey/dotfiles"
	echo
	exit 1
}


function initialize() {
	if ! command -v wget &> /dev/null; then
		sudo pacman -S --noconfirm wget
	fi

	if ! command -v rsync &> /dev/null; then
		sudo pacman -S --noconfirm rsync
	fi

	if ! command -v unzip &> /dev/null; then
		sudo pacman -S --noconfirm unzip
	fi

	test -f arch-packages.sh || wget -O arch-packages.sh https://raw.githubusercontent.com/druxorey/dotfiles/master/arch-packages.sh
	source "$(dirname "$0")/arch-packages.sh"
	clear
}


function installPackage() {
	local pacman="sudo pacman -S --noconfirm"
	local yay="yay -S --noconfirm"
	local packageManager="$1"
	shift

	if [ "$packageManager" == "pacman" ]; then
		commandExecutor="$pacman"
	elif [ "$packageManager" == "yay" ]; then
		commandExecutor="$yay"
	fi

	for package in "${@}"; do
		echo -e "${RUNNING}Installing ${END}$package"
		$commandExecutor $package
		if [ $? -eq 0 ]; then
			echo -e "${SUCCESS}The package has been installed correctly${END}"
		else
			echo -e "${FAILED} !WARNING! The following package could not be installed: ${END}$package"
		fi
	done
}


function enableService() {
	local enableCommand="sudo systemctl enable"
	shift

	for service in "${@}"; do
		echo -e "${RUNNING}Enabling ${END}$service"
		$enableCommand $service
		if [ $? -eq 0 ]; then
			echo -e "${SUCCESS}The service has been enabled correctly${END}"
		else
			echo -e "${FAILED} !WARNING! The following service could not be enabled: ${END}$service"
		fi
	done
}


function copyDotfiles() {
	local dotfilesPath="6PYqO7W9oEQJb04nSoqajW26Xexnbw3z/"
	local gitClone="git clone https://github.com/druxorey/dotfiles.git $dotfilesPath"

	[ ! -d "$HOME/.config" ] && mkdir "$HOME/.config"
	[ ! -d "$HOME/.local" ] && mkdir "$HOME/.local"
	[ ! -d "$HOME/.local/share" ] && mkdir "$HOME/.local/share"
	[ ! -d "$HOME/.local/share/icons" ] && mkdir "$HOME/.local/share/icons"
	[ ! -d "$HOME/.local/share/themes" ] && mkdir "$HOME/.local/share/themes"

	if $gitClone; then
		rsync -av --delete $dotfilesPath/config/* $HOME/.config/
		mv -f $HOME/.config/zshrc $HOME/.zshrc
		mv -f $HOME/.config/bashrc $HOME/.bashrc
		rm -rf $dotfilesPath/
		echo -e "${SUCCESS}The dotfiles have been cloned correctly${END}"
	else
		echo -e "${FAILED} !WARNING! The dotfiles could not be cloned"
	fi

	wget "https://github.com/dracula/gtk/archive/master.zip" -O master.zip
	wget "https://github.com/dracula/gtk/files/5214870/Dracula.zip" -O Dracula.zip

	if [[ -f "master.zip" && -f "Dracula.zip" ]]; then
		unzip Dracula.zip
		mv -f Dracula $HOME/.local/share/icons/
		rm -rf Dracula.zip
		unzip master.zip
		mv gtk-master Dracula
		mv -f Dracula $HOME/.local/share/themes/
		rm -rf master.zip
		echo -e "${SUCCESS}The gtk theme has been cloned correctly${END}"
	else
		echo -e "${FAILED} !WARNING! The gtk theme could not be cloned"
	fi

	git clone https://github.com/zsh-users/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions

	if [[ -d "zsh-syntax-highlighting" && -d "zsh-autosuggestions" ]]; then
		mv -f zsh-syntax-highlighting $HOME/.config/zsh/zsh-syntax-highlighting
		mv -f zsh-autosuggestions $HOME/.config/zsh/zsh-autosuggestions
		echo -e "${SUCCESS}The zsh plugins have been cloned correctly${END}"
	else
		echo -e "${FAILED} !WARNING! The zsh plugins could not be cloned"
	fi

	git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm

	if [[ -d "$HOME/.config/tmux/plugins/tpm" ]]; then
		echo -e "${SUCCESS}The tmux plugin has been cloned correctly${END}"
	else
		echo -e "${FAILED} !WARNING! The tmux plugin could not be cloned"
	fi
}


function askUser() {
	local question="$1"
	local action="$2"

	if [[ $isAutomated -eq 0 ]]; then
		echo -ne "${QUESTION} $question [Y/n]: ${END}"
		read -r output
		echo
		output=${output,,}
	fi

	[[ -z $output ]] && output='y'

	if [[ $output == 'y' ]]; then
		eval "$action"
	else
		echo -e "${FAILED} ⚠ !The installation will not be executed!${END}"
	fi
}


function main() {

	while getopts ":ah" opt; do
		case ${opt} in
			a ) isAutomated = 1 ;;
			h ) help ;;
			* ) echo "Invalid Option: -$OPTARG" 1>&2 ; exit 1 ;;
		esac
	done

	initialize

	shift $((OPTIND -1))

	echo -e "${LINE}${TITLE} [========== WELCOME TO DRUXOREY'S ARCH LINUX BOOTSTRAP ==========] ${END}${LINE}"

	installCommand='sudo pacman -Syu'
	echo -e "It is necessary to update the system to ensure the correct functioning of the script."
	askUser "► Proceed with the update?" "$installCommand"

	installCommand="cd && git clone https://aur.archlinux.org/yay.git && cd yay/ && makepkg -si && cd .. && sudo rm -r yay/"
	askUser "► Do you want to install yay?" "$installCommand"

	clear
	echo -e "${TITLE} [========== PACKAGE INSTALLATION ==========]"

	pacmanCategories=("core" "essential" "utils" "drivers" "customization" "gui")
	for category in "${pacmanCategories[@]}"; do
		installCommand="installPackage "pacman" "\${${category}_Packages[@]}""
		echo -e "${LINE}${RUNNING}The next pacman packages will be installing:${END} $(eval echo \${${category}_Packages[@]})"
		askUser "► Proceed with the installation?" "$installCommand"
	done

	aurCategories=("terminal" "gui")
	for category in "${aurCategories[@]}"; do
		installCommand="installPackage "yay" "\${${category}_AurPackages[@]}""
		echo -e "${LINE}${RUNNING}The next pacman packages will be installing:${END} $(eval echo \${${category}_AurPackages[@]})"
		askUser "► Proceed with the installation?" "$installCommand"
	done

	clear
	echo -e "${TITLE} [========== SERVICE ENABLEMENT ==========]"

	installCommand='enableService "${drivers_Services[@]}"'
	askUser "► Proceed enabling the services?" "$installCommand"

	clear
	echo -e "${TITLE} [========== ZSH INSTALLATION ==========]"

	installCommand='sudo pacman -S --noconfirm zsh && chsh -s /bin/zsh'
	askUser "► Proceed installing zsh and make it the default shell?" "$installCommand"

	clear
	echo -e "${TITLE} [========== CUSTOMIZATION ==========]"

	echo -e "${FAILED} ⚠ !WARNING THE NEXT COMMAND WILL OVERRIDE EXISTING FILES!${END}"
	askUser "► Proceed copying the dotfiles?" "copyDotfiles"

	clear

	echo -e "${LINE}${TITLE} The script has finished running, enjoy your system :) ${END}"
	echo -e "${TITLE} Made by: github.com/druxorey${END}${LINE}"
}

main $@
