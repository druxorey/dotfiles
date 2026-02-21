#!/bin/bash

declare FORMAT_SUCCESS="\e[1;32m[SUCCESS]"
declare FORMAT_ERROR="\e[1;31m[ERROR]"
declare FORMAT_INFO="\e[0;34m"
declare FORMAT_RESET="\e[0m"

declare PACKAGES_BASE_SOURCE="https://raw.githubusercontent.com/druxorey/dotfiles/refs/heads/main/drx-base.packages"
declare PACKAGES_EXTRA_SOURCE="https://raw.githubusercontent.com/druxorey/dotfiles/refs/heads/main/drx-extra.packages"

declare doSystemUpdate=false
declare installMode=""
declare installBase=false
declare installExtra=false
declare installYay=false
declare installZsh=false
declare installDotfiles=false
declare enableServices=false
declare configureGui=false

function runConfigurationUi() {
	local updateSystemResponse
	dialog --clear --title "System Update" --yesno "\nDo you want to update the system before proceeding?" 8 50
	updateSystemResponse=$?
	
	if [[ $updateSystemResponse -eq 0 ]]; then
		doSystemUpdate=true
	fi

	installMode=$(dialog --clear --title "Installation Mode" --menu "\nSelect the installation type you want to perform:" 13 60 3 \
		"Minimal" "Base packages, Yay, Zsh, Dotfiles, Services" \
		"Full"    "Minimal + Extra packages + GUI configs" \
		"Custom"  "Choose specific components" \
		3>&1 1>&2 2>&3)

	if [[ -z "$installMode" ]]; then
		clear
		echo -e "${FORMAT_ERROR} Installation canceled by user.${FORMAT_RESET}"
		exit 0
	fi

	if [[ "$installMode" == "Minimal" ]]; then
		installBase=true
		installYay=true
		installZsh=true
		installDotfiles=true
		enableServices=true

	elif [[ "$installMode" == "Full" ]]; then
		installBase=true
		installExtra=true
		installYay=true
		installZsh=true
		installDotfiles=true
		enableServices=true
		configureGui=true

	elif [[ "$installMode" == "Custom" ]]; then
		local customChoices
		customChoices=$(dialog --clear --title "Custom Installation" --checklist "\nSelect components to install:" 15 60 5 \
			"Base"     "Install base packages and services" off \
			"Extra"    "Install extra packages" off \
			"Yay"      "Install AUR helper (yay)" off \
			"Zsh"      "Install and set Zsh as default" off \
			"Dotfiles" "Copy dotfiles" off \
			"Services" "Enable services" off \
			3>&1 1>&2 2>&3)

		[[ $customChoices == *"Base"* ]] && installBase=true
		[[ $customChoices == *"Services"* ]] && enableServices=true
		[[ $customChoices == *"Extra"* ]] && installExtra=true
		[[ $customChoices == *"Yay"* ]] && installYay=true
		[[ $customChoices == *"Zsh"* ]] && installZsh=true
		[[ $customChoices == *"Dotfiles"* ]] && installDotfiles=true
	fi

	clear
}


function fetchPackageLists() {
	echo -e "\n${FORMAT_INFO}Fetching package lists from repository${FORMAT_RESET}"

	curl -sL "$PACKAGES_BASE_SOURCE" -o /tmp/drx-base.packages
	curl -sL "$PACKAGES_EXTRA_SOURCE" -o /tmp/drx-extra.packages

	source /tmp/drx-base.packages || exit 1
	source /tmp/drx-extra.packages || exit 1
}


function updateSystem() {
	echo -e "\n${FORMAT_INFO}Updating system${FORMAT_RESET}"
	sudo pacman -Syu --noconfirm
}


function installAurHelper() {
	if ! command -v yay &> /dev/null; then
		echo -e "\n${FORMAT_INFO}Installing YAY${FORMAT_RESET}"
		sudo pacman -S --needed --noconfirm git base-devel
		rm -rf /tmp/yay
		git clone https://aur.archlinux.org/yay.git /tmp/yay
		(cd /tmp/yay && makepkg -si --noconfirm)
	else
		echo -e "\n${FORMAT_SUCCESS} YAY is already installed.${FORMAT_RESET}"
	fi
}


function installBasePackages() {
	echo -e "\n${FORMAT_INFO}Installing Base Pacman Packages${FORMAT_RESET}"
	sudo pacman -S --needed --noconfirm "${base_pacman_packages[@]}"

	if [[ "$installYay" == true ]]; then
		echo -e "\n${FORMAT_INFO}Installing Base AUR Packages${FORMAT_RESET}"
		yay -S --needed --noconfirm "${base_aur_packages[@]}"
	fi
}


function installExtraPackages() {
	echo -e "\n${FORMAT_INFO}Installing Extra Pacman Packages${FORMAT_RESET}"
	sudo pacman -S --needed --noconfirm "${extra_pacman_packages[@]}"

	if [[ "$installYay" == true ]]; then
		echo -e "\n${FORMAT_INFO}Installing Extra AUR Packages${FORMAT_RESET}"
		yay -S --needed --noconfirm "${extra_aur_packages[@]}"
	fi
}


function installZshShell() {
	echo -e "\n${FORMAT_INFO}Installing and configuring ZSH${FORMAT_RESET}"
	sudo pacman -S --needed --noconfirm zsh
	sudo chsh -s /bin/zsh "$USER"
}


function copyDotfiles() {
	echo -e "\n${FORMAT_INFO}Copying dotfiles${FORMAT_RESET}"
	# Empty function as requested
}


function enableSystemServices() {
	local servicesToEnable=("bluetooth" "NetworkManager")
	
	echo -e "\n${FORMAT_INFO}Enabling System Services${FORMAT_RESET}"
	for service in "${servicesToEnable[@]}"; do
		if [[ $(systemctl is-enabled "$service" 2>/dev/null) != "enabled" ]]; then
			sudo systemctl enable --now "$service"
			echo -e "${FORMAT_SUCCESS} Service $service enabled.${FORMAT_RESET}"
		else
			echo -e "Service $service is already enabled."
		fi
	done
}

function configureGraphicalEnvironment() {
	echo -e "\n${FORMAT_INFO}Configuring Graphical Environment${FORMAT_RESET}"
	# Empty function for you to implement BSPWM, Polybar, etc.
}


function main() {
	if ! command -v dialog &> /dev/null; then
		echo -e "${FORMAT_INFO}Installing dialog to display the UI${FORMAT_RESET}"
		sudo pacman -Sy --noconfirm dialog > /dev/null 2>&1
	fi

	runConfigurationUi

	echo -e "${FORMAT_INFO}Starting execution phase${FORMAT_RESET}"
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	if [[ "$doSystemUpdate" == true ]]; then
		updateSystem
	fi

	if [[ "$installBase" == true || "$installExtra" == true ]]; then
		fetchPackageLists
	fi

	if [[ "$installYay" == true ]]; then
		installAurHelper
	fi

	if [[ "$installBase" == true ]]; then
		installBasePackages
	fi

	if [[ "$installExtra" == true ]]; then
		installExtraPackages
	fi

	if [[ "$enableServices" == true ]]; then
		enableSystemServices
	fi

	if [[ "$installZsh" == true ]]; then
		installZshShell
	fi

	if [[ "$installDotfiles" == true ]]; then
		copyDotfiles
	fi

	if [[ "$configureGui" == true ]]; then
		configureGraphicalEnvironment
	fi

	echo -e "\n${FORMAT_SUCCESS} The script has finished running. Enjoy your system! :)${FORMAT_RESET}"
}

main "$@"
