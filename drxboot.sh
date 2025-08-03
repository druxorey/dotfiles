#!/bin/bash

TITLE="\e[1;35m"
RUNNING="\e[34m"
QUESTION="\e[36m"
SUCCESS="\e[1;32m"
FAILED="\e[1;31m"
END="\e[0m"
LINE="\n"

PACKAGES_LINK="https://raw.githubusercontent.com/druxorey/dotfiles/master/deps.pkglist"

IS_AUTOMATED=0
IS_YAY_INSTALLED=0

function help() {
	echo
	echo -e "${TITLE}USAGE:${END} arch-bootstrap [OPTION]"
	echo
	echo -e "${TITLE}DESCRIPTION:${END} The arch-bootstrap script automates the initial installation and configuration"
	echo "        of an Arch Linux system. It updates the system, installs essential packages"
	echo "        (both from Pacman and AUR), and enables necessary services like the firewall"
	echo "        and the login manager. It’s particularly useful for users who want a quick and"
	echo "        straightforward installation process."
	echo
	echo -e "${TITLE}OPTIONS:${END}"
	echo "  -h    Shows this help."
	echo "  -a    Automated mode. The script will not ask for user confirmation."
	echo
	echo -e "${TITLE}Report bugs to https://github.com/druxorey/dotfiles${END}"
	echo
	exit 1
}

# Function to display a waiting screen using dialog
function waitScreen() {
	dialog --title "$1" --infobox "\n           Installing, please wait..." 5 50
}

# Function to install essential dependencies
function installDependencies() {
	local dependencies=(
		"git"
		"wget"
		"rsync"
		"unzip"
	)

	local totalDependencies=$(( ${#dependencies[@]}))
	local titleStart="  WELCOME TO DRUXOREY'S ARCH LINUX BOOTSTRAP  "
	local descriptionStart="\n               Starting Script..."

	dialog --title "$titleStart" --gauge "$descriptionStart" 8 50 0 < <(
		# Remove pacman lock file if it exists
		[[ -f /var/lib/pacman/db.lck ]] && sudo rm /var/lib/pacman/db.lck

		for index in "${!dependencies[@]}"; do
			local package="${dependencies[$index]}"

			# Install package if not already installed
			if ! command -v $package &> /dev/null; then
				sudo pacman -S --noconfirm --needed $package > /dev/null 2>&1
			fi

			echo $(( (index + 1) * 100 / totalDependencies))
			sleep 0.125
		done

		# Install yay if not already installed
		command -v yay &> /dev/null && IS_YAY_INSTALLED=1
	)

	# Fetch additional dependencies from a remote package list
	local scriptDependencies=$(curl -s $PACKAGES_LINK)
	eval "$scriptDependencies"
}

# Function to install packages (Pacman and AUR)
function installPackages() {
	local type="$1"
	local descInstallation="\n                 Please wait..."

	local pacman="sudo pacman -S --noconfirm --needed"
	local yay="yay -S --noconfirm"

	local -n main_packages="${type}_main_packages"
	local totalPackages=${#main_packages[@]}

	local titleInstallation=
	dialog --title "INSTALLING PACMAN PACKAGES" --gauge "$descInstallation" 8 50 0 < <(
		for index in "${!main_packages[@]}"; do
			package="${main_packages[$index]}"
			$pacman $package > /dev/null 2>&1
			echo $(( (index + 1) * 100 / totalPackages))
			sleep 0.125
		done
	)

	[[ $IS_YAY_INSTALLED == 0 ]] && return

	local -n aur_packages="${type}_aur_packages"
	local totalPackages=${#aur_packages[@]}

	dialog --title "INSTALLING YAY PACKAGES" --gauge "$descInstallation" 8 50 0 < <(
		for index in "${!aur_packages[@]}"; do
			package="${aur_packages[$index]}"
			$yay $package > /dev/null 2>&1
			echo $(( (index + 1) * 100 / totalPackages))
			sleep 0.125
		done
	)
}

# Function to enable necessary system services
function enableServices() {
	local enableCommand="sudo systemctl enable"
	local totalServices=${#drivers_Services[@]}

	local descInstallation="\n                 Please wait..."

	dialog --title "ENABLING SERVICES" --gauge "$descInstallation" 8 50 0 < <(
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

# Function to clone and configure dotfiles
function copyDotfiles() {
	(
		# Define paths and clone dotfiles repository
		local dotfilesPath="6PYqO7W9oEQJb04nSoqajW26Xexnbw3z/"
		local gitClone="git clone https://github.com/druxorey/dotfiles.git $dotfilesPath"

		# Ensure necessary directories exist
		[ ! -d "$HOME/.config" ] && mkdir "$HOME/.config"
		[ ! -d "$HOME/.local" ] && mkdir "$HOME/.local"
		[ ! -d "$HOME/.local/share" ] && mkdir "$HOME/.local/share"
		[ ! -d "$HOME/.local/share/icons" ] && mkdir "$HOME/.local/share/icons"
		[ ! -d "$HOME/.local/share/themes" ] && mkdir "$HOME/.local/share/themes"

		# Clone and copy dotfiles
		if $gitClone; then
			rsync -av --delete $dotfilesPath/config/* $HOME/.config/
			mv -f $HOME/.config/zshrc $HOME/.zshrc
			mv -f $HOME/.config/bashrc $HOME/.bashrc
			rm -rf $dotfilesPath/
			echo -e "${SUCCESS}The dotfiles have been cloned correctly${END}"
		else
			echo -e "${FAILED} !WARNING! The dotfiles could not be cloned"
		fi

		# Download and install GTK themes
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

		# Clone Zsh plugins
		git clone https://github.com/zsh-users/zsh-syntax-highlighting
		git clone https://github.com/zsh-users/zsh-autosuggestions

		if [[ -d "zsh-syntax-highlighting" && -d "zsh-autosuggestions" ]]; then
			mv -f zsh-syntax-highlighting $HOME/.config/zsh/zsh-syntax-highlighting
			mv -f zsh-autosuggestions $HOME/.config/zsh/zsh-autosuggestions
			echo -e "${SUCCESS}The zsh plugins have been cloned correctly${END}"
		else
			echo -e "${FAILED} !WARNING! The zsh plugins could not be cloned"
		fi

		# Clone Tmux plugin manager
		git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm

		if [[ -d "$HOME/.config/tmux/plugins/tpm" ]]; then
			echo -e "${SUCCESS}The tmux plugin has been cloned correctly${END}"
		else
			echo -e "${FAILED} !WARNING! The tmux plugin could not be cloned"
		fi

		# Download and set wallpaper
		wget -O image.png "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/b4e7c8d7-7c38-48d5-bbb7-c77ad1088d81/dje4t3w-b2ab79c6-de7c-4d59-835c-346b46ea387d.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2I0ZTdjOGQ3LTdjMzgtNDhkNS1iYmI3LWM3N2FkMTA4OGQ4MVwvZGplNHQzdy1iMmFiNzljNi1kZTdjLTRkNTktODM1Yy0zNDZiNDZlYTM4N2QucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.1moV0pK662rX4bVdC07B0BR9ls4Zchu8jP3cQL3aj5o"

		[[ ! -d "$HOME/Pictures/Wallpapers/" ]] && mkdir "$HOME/Pictures/Wallpapers/"
		mv -f image.png "$HOME/Pictures/Wallpapers/"

		if ! command -v nitrogen &> /dev/null; then
			nitrogen "$HOME/Pictures/Wallpapers/" > /dev/null 2>&0
			nitrogen --set-zoom-fill "$HOME/Pictures/Wallpapers/image.png" > /dev/null 2>&1
		fi
	)
}


function main() {
	# Parse command-line options
	while getopts ":ah" opt; do
		case ${opt} in
			a ) IS_AUTOMATED=1 ;;
			h ) help ;;
			* ) echo "Invalid Option: -$OPTARG" 1>&2 ; exit 1 ;;
		esac
	done

	shift $((OPTIND -1))

	# Elevate privileges and keep sudo session alive
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# Ensure dialog is installed
	if ! command -v dialog &> /dev/null; then
		echo -e "Waiting for dialog to be installed..."
		sudo pacman -S --noconfirm --needed dialog > /dev/null 2>&1
	fi

	installDependencies

	local descUpdateSystem="\nIt is necessary to update the system to ensure the correct functioning of the script. \n\n            Do you want to update?"
	dialog --clear --title "" --yesno "$descUpdateSystem" 10 50
	local responseUpdateSystem=$?

	if [[ $IS_YAY_INSTALLED == 0 ]]; then
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
			IS_YAY_INSTALLED=1
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
