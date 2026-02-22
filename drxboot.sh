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

declare -a customPacmanPackages=()
declare -a customAurPackages=()
declare customInstallZsh=true
declare customInstallDotfiles=true
declare customEnableServices=true
declare hasRunCustomSetup=false

function promptCustomPacman() {
	local options=()
	local status

	for pkg in "${base_pacman_packages[@]}"; do
		status="OFF"
		if [[ "$hasRunCustomSetup" == false ]] || [[ " ${customPacmanPackages[*]} " =~ " ${pkg} " ]]; then
			status="ON"
		fi
		options+=("$pkg" "Base" "$status")
	done

	for pkg in "${extra_pacman_packages[@]}"; do
		status="OFF"
		if [[ "$hasRunCustomSetup" == true ]] && [[ " ${customPacmanPackages[*]} " =~ " ${pkg} " ]]; then
			status="ON"
		fi
		options+=("$pkg" "Extra" "$status")
	done
	
	local choices
	if choices=$(dialog --clear --no-lines --no-cancel --title "Pacman Packages" --checklist "\nSelect Pacman packages to install:" 40 60 10 "${options[@]}" 3>&1 1>&2 2>&3); then
		choices=$(echo "$choices" | tr -d '"')
		customPacmanPackages=($choices)
	fi
}


function promptCustomAur() {
	local options=()
	local status

	for pkg in "${base_aur_packages[@]}"; do
		status="OFF"
		if [[ "$hasRunCustomSetup" == false ]] || [[ " ${customAurPackages[*]} " =~ " ${pkg} " ]]; then
			status="ON"
		fi
		options+=("$pkg" "Base" "$status")
	done

	for pkg in "${extra_aur_packages[@]}"; do
		status="OFF"
		if [[ "$hasRunCustomSetup" == true ]] && [[ " ${customAurPackages[*]} " =~ " ${pkg} " ]]; then
			status="ON"
		fi
		options+=("$pkg" "Extra" "$status")
	done
	
	local choices
	if choices=$(dialog --clear --no-lines --no-cancel --title "AUR Packages" --checklist "\nSelect AUR packages to install:" 40 60 10 "${options[@]}" 3>&1 1>&2 2>&3); then
		choices=$(echo "$choices" | tr -d '"')
		customAurPackages=($choices)
	fi
}


function promptCustomServices() {
	if dialog --clear --no-lines --title "System Services" --yesno "\nDo you want to enable default system services?" 8 50; then
		customEnableServices=true
	else
		customEnableServices=false
	fi
}


function promptCustomZsh() {
	if dialog --clear --no-lines --title "ZSH Shell" --yesno "\nDo you want to install and set ZSH as default?" 8 50; then
		customInstallZsh=true
	else
		customInstallZsh=false
	fi
}


function promptCustomDotfiles() {
	if dialog --clear --no-lines --title "Dotfiles" --yesno "\nDo you want to copy the dotfiles?" 8 50; then
		customInstallDotfiles=true
	else
		customInstallDotfiles=false
	fi
}


function showModifyMenu() {
	local choice
	if choice=$(dialog --clear --no-lines --title "Modify Configuration" --menu "\nSelect what you want to change:" 15 50 5 \
		"1" "Pacman Packages" \
		"2" "AUR Packages" \
		"3" "Install Zsh" \
		"4" "Copy Dotfiles" \
		"5" "Enable Services" \
		3>&1 1>&2 2>&3); then
		
		case "$choice" in
			1) promptCustomPacman ;;
			2) promptCustomAur ;;
			3) promptCustomZsh ;;
			4) promptCustomDotfiles ;;
			5) promptCustomServices ;;
		esac
	fi
}


function showCustomSummary() {
	local yayStatus="No"
	if [[ ${#customAurPackages[@]} -gt 0 ]]; then
		yayStatus="Yes (Auto)"
	fi

	local summaryText="\nCurrent Custom Configuration:\n\n"
	summaryText+="Pacman Packages: ${#customPacmanPackages[@]} selected\n"
	summaryText+="AUR Packages:    ${#customAurPackages[@]} selected\n"
	summaryText+="Install Yay:     $yayStatus\n"
	summaryText+="Install Zsh:     $( [[ "$customInstallZsh" == true ]] && echo "Yes" || echo "No" )\n"
	summaryText+="Copy Dotfiles:   $( [[ "$customInstallDotfiles" == true ]] && echo "Yes" || echo "No" )\n"
	summaryText+="Enable Services: $( [[ "$customEnableServices" == true ]] && echo "Yes" || echo "No" )\n\n"
	summaryText+="Do you want to confirm this configuration?"

	dialog --clear --no-lines --title "Custom Installation Summary" --yes-label "Confirm" --no-label "Modify" --yesno "$summaryText" 18 60
	
	if [[ $? -eq 0 ]]; then
		return 0
	else
		showModifyMenu
		return 1
	fi
}


function runCustomWizard() {
	dialog --infobox "\nFetching package lists for Custom setup..." 5 50
	fetchPackageLists "quiet"

	if [[ "$hasRunCustomSetup" == false ]]; then
		promptCustomPacman
		promptCustomAur
		promptCustomZsh
		promptCustomDotfiles
		promptCustomServices
		hasRunCustomSetup=true
	fi

	while true; do
		if showCustomSummary; then
			installMode="CustomReady"
			if [[ ${#customAurPackages[@]} -gt 0 ]]; then
				installYay=true
			else
				installYay=false
			fi
			installZsh=$customInstallZsh
			installDotfiles=$customInstallDotfiles
			enableServices=$customEnableServices
			break
		fi
	done
}


function runConfigurationUi() {
	local updateSystemResponse
	dialog --clear --no-lines --title "System Update" --yesno "\nDo you want to update the system before proceeding?" 8 50
	updateSystemResponse=$?
	
	if [[ $updateSystemResponse -eq 0 ]]; then
		doSystemUpdate=true
	fi

	installMode=$(dialog --clear --no-lines --no-ok --no-cancel --title "Installation Mode" --menu "" 9 50 3 \
		"Minimal" "" \
		"Full"    "" \
		"Custom"  "" \
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
		runCustomWizard
	fi

	clear
}


function fetchPackageLists() {
	local quiet=$1
	if [[ "$quiet" != "quiet" ]]; then
		echo -e "\n${FORMAT_INFO}Fetching package lists from repository${FORMAT_RESET}"
	fi

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


function installCustomPackagesList() {
	if [[ ${#customPacmanPackages[@]} -gt 0 ]]; then
		echo -e "\n${FORMAT_INFO}Installing Custom Pacman Packages${FORMAT_RESET}"
		sudo pacman -S --needed --noconfirm "${customPacmanPackages[@]}"
	fi

	if [[ "$installYay" == true ]] && [[ ${#customAurPackages[@]} -gt 0 ]]; then
		echo -e "\n${FORMAT_INFO}Installing Custom AUR Packages${FORMAT_RESET}"
		yay -S --needed --noconfirm "${customAurPackages[@]}"
	fi
}


function installZshShell() {
	echo -e "\n${FORMAT_INFO}Installing and configuring ZSH${FORMAT_RESET}"
	sudo pacman -S --needed --noconfirm zsh
	sudo chsh -s /bin/zsh "$USER"
}


function copyDotfiles() {
	echo -e "\n${FORMAT_INFO}Copying dotfiles${FORMAT_RESET}"
	# TODO: Copy all the configuration files to the correct directory
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
	# TODO: Installation and configurations of fonts and other graphical settings
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

	if [[ "$installMode" == "Minimal" || "$installMode" == "Full" ]]; then
		if [[ "$installBase" == true || "$installExtra" == true ]]; then
			fetchPackageLists
		fi
	fi

	if [[ "$installYay" == true ]]; then
		installAurHelper
	fi

	if [[ "$installMode" == "Minimal" || "$installMode" == "Full" ]]; then
		if [[ "$installBase" == true ]]; then
			installBasePackages
		fi

		if [[ "$installExtra" == true ]]; then
			installExtraPackages
		fi
	elif [[ "$installMode" == "CustomReady" ]]; then
		installCustomPackagesList
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
