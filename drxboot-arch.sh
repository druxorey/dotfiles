#!/bin/bash

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

TITLE="\e[1;35m"
RUNNING="\e[35m"
QUESTION="\e[36m"
SUCCESS="\e[1;32m"
FAILED="\e[1;31m"
END="\e[0m"
LINE="\n"

IS_AUTOMATED=0

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

function waitScreen() {
	local title="$1"
	dialog --title "$title" --infobox "\n           Installing, please wait..." 5 50
}


function installDependencies() {

	if [[ -f /var/lib/pacman/db.lck ]]; then
		sudo rm /var/lib/pacman/db.lck
	fi

	dependencies=(
		"git"
		"wget"
		"rsync"
		"unzip"
	)

	local totalDependencies=$(( ${#dependencies[@]} + 1))
	local titleStart="  WELCOME TO DRUXOREY'S ARCH LINUX BOOTSTRAP  "
	local descriptionStart="\n               Starting Script..."
	dialog --title "$titleStart" --gauge "$descriptionStart" 8 50 0 < <(
		for index in "${!dependencies[@]}"; do
			package="${dependencies[$index]}"

			if ! command -v $package &> /dev/null; then
				sudo pacman -S --noconfirm --needed $package > /dev/null 2>&1
			fi

			echo $(( (index + 1) * 100 / totalDependencies))
			sleep 0.125
		done
	)

	arch_deps_content=$(curl -s https://raw.githubusercontent.com/druxorey/dotfiles/master/arch-deps.pkglist)
	eval "$arch_deps_content"
}


function installPackages() {
	local type="$1"
	local pacman="sudo pacman -S --noconfirm --needed"
	local yay="yay -S --noconfirm"

	local -n main_packages="${type}_main_packages"
	local totalPackages=${#main_packages[@]}
	local descInstallation="\n                 Please wait..."

	local titleInstallation="INSTALLING PACMAN PACKAGES"
	dialog --title "$titleInstallation" --gauge "$descInstallation" 8 50 0 < <(
		for index in "${!main_packages[@]}"; do
			package="${main_packages[$index]}"
			echo $(( (index + 1) * 100 / totalPackages))
			$pacman $package > /dev/null 2>&1
			sleep 0.125
		done
	)

	local -n aur_packages="${type}_aur_packages"
	local totalPackages=${#main_packages[@]}

	local titleInstallation="INSTALLING YAY PACKAGES"
	dialog --title "$titleInstallation" --gauge "$descInstallation" 8 50 0 < <(
		for index in "${!main_packages[@]}"; do
			package="${main_packages[$index]}"
			echo $(( (index + 1) * 100 / totalPackages))
			$pacman $package > /dev/null 2>&1
			sleep 0.125
		done
	)
}


function enableServices() {
	local enableCommand="sudo systemctl enable"
	local totalServices=${#drivers_Services[@]}

	local titleServices="ENABLING SERVICES"
	local desc="Please wait..."

	dialog --title "$titleServices" --gauge "$descInstallation" 8 50 0 < <(
		for index in "${!drivers_services[@]}"; do
			service="${drivers_Services[$index]}"

			if [[ $(sudo systemctl is-active "$service") == "inactive" ]]; then
				$enableCommand $service > /dev/null 2>&1
			fi

			echo $(( (index + 1) * 100 / totalServices))
			sleep 0.125
		done
	)
}


function copyDotfiles() {
	(
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
	)
}


function main() {
	while getopts ":ah" opt; do
		case ${opt} in
			a ) IS_AUTOMATED=1 ;;
			h ) help ;;
			* ) echo "Invalid Option: -$OPTARG" 1>&2 ; exit 1 ;;
		esac
	done

	shift $((OPTIND -1))

	if ! command -v dialog &> /dev/null; then
		echo -e "Waiting for dialog to be installed..."
		sudo pacman -S --noconfirm --needed dialog > /dev/null 2>&1
	fi

	installDependencies

	local descUpdateSystem="\nIt is necessary to update the system to ensure the correct functioning of the script. \n\n            Do you want to update?"
	dialog --clear --title "" --yesno "$descUpdateSystem" 10 50
	local responseUpdateSystem=$?

	if ! command -v yay &> /dev/null; then
		local titleAurInstallation="AUR INSTALLATION REQUIRED"
		local descAurInstallation="\n         Do you want to install yay?"
		dialog --clear --title "" --yesno "$descAurInstallation" 7 50
		responseAurInstallation=$?
	fi

	local descInstallationType="\nSelect the installation type you want to perform:\n "
	local responseTypeInstallation=$(dialog --clear --no-cancel --title "" --menu "$descInstallationType" 13 50 2 \
		1 "Minimal" \
		2 "Desktop" 2>&1 >/dev/tty)

	local descZshInstallation="\nDo you want to install zsh and make it the default shell?"
	dialog --clear --title "" --yesno "$descZshInstallation" 8 50
	local responseZshInstallation=$?

	local descDotfilesInstallation="\n    Do you want to install the dotfiles?"
	dialog --clear --title "" --yesno "$descDotfilesInstallation" 7 50
	local responseDotfilesInstallation=$?

	if [[ $responseUpdateSystem == 0 ]]; then
		waitScreen "UPDATING SYSTEM"
		sudo pacman -Syu --noconfirm > /dev/null 2>&1
	fi

	if [[ $responseAurInstallation == 0 ]]; then
		(
			waitScreen "INSTALLING YAY"
			sleep 3
			clear
			cd /tmp
			git clone https://aur.archlinux.org/yay.git
			cd yay
			makepkg -si --noconfirm
		)
	fi

	case $responseTypeInstallation in
		1)
			installPackages "minimal"
			;;
		2)
			installPackages "minimal"
			installPackages "desktop"
			;;
	esac

	enableServices

	if [[ $responseZshInstallation == 0 ]]; then
		waitScreen "INSTALLING ZSH"
		sudo pacman -S --noconfirm zsh > /dev/null 2>&1
		sudo chsh -s /bin/zsh
	fi

	if [[ $responseDotfilesInstallation == 0 ]]; then
		waitScreen "INSTALLING DOTFILES"
		copyDotfiles > /dev/null 2>&1
	fi

	clear

	echo -e "${LINE}${TITLE} The script has finished running, enjoy your system :) ${END}"
	echo -e "${TITLE} Made by: github.com/druxorey${END}${LINE}"
}

main $@
