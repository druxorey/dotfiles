#!/bin/bash

declare FORMAT_SUCCESS="\e[1;32m[SUCCESS]"
declare FORMAT_ERROR="\e[1;31m[ERROR]"
declare FORMAT_INFO="\e[0;35m"
declare FORMAT_RESET="\e[0m"

declare PACKAGES_BASE_SOURCE="https://raw.githubusercontent.com/druxorey/dotfiles/refs/heads/main/drx-base.packages"
declare PACKAGES_EXTRA_SOURCE="https://raw.githubusercontent.com/druxorey/dotfiles/refs/heads/main/drx-extra.packages"
declare SERVICES_TO_ENABLE=("bluetooth" "NetworkManager" "ufw" "tlp" "smb" "nmb" "cups" "lightdm" "ipp-usb" "ollama")

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
	local sortedBasePacman
	local sortedExtraPacman

	mapfile -t sortedBasePacman < <(printf "%s\n" "${base_pacman_packages[@]}" | sort)
	for pkg in "${sortedBasePacman[@]}"; do
		status="OFF"
		[[ "$hasRunCustomSetup" == false ]] || [[ " ${customPacmanPackages[*]} " =~ " ${pkg} " ]] && status="ON"
		options+=("$pkg" "Base" "$status")
	done

	mapfile -t sortedExtraPacman < <(printf "%s\n" "${extra_pacman_packages[@]}" | sort)
	for pkg in "${sortedExtraPacman[@]}"; do
		status="OFF"
		[[ "$hasRunCustomSetup" == true ]] && [[ " ${customPacmanPackages[*]} " =~ " ${pkg} " ]] && status="ON"
		options+=("$pkg" "Extra" "$status")
	done
	
	local choices
	if choices=$(dialog --clear --no-lines --no-cancel --title "Pacman Packages" --checklist "\nSelect Pacman packages to install:" 40 60 10 "${options[@]}" 3>&1 1>&2 2>&3); then
		choices=$(printf "%s" "$choices" | tr -d '"')
		customPacmanPackages=($choices)
	fi
}


function promptCustomAur() {
	local options=()
	local status
	local sortedBaseAur
	local sortedExtraAur

	mapfile -t sortedBaseAur < <(printf "%s\n" "${base_aur_packages[@]}" | sort)
	for pkg in "${sortedBaseAur[@]}"; do
		status="OFF"
		[[ "$hasRunCustomSetup" == false ]] || [[ " ${customAurPackages[*]} " =~ " ${pkg} " ]] && status="ON"
		options+=("$pkg" "Base" "$status")
	done

	mapfile -t sortedExtraAur < <(printf "%s\n" "${extra_aur_packages[@]}" | sort)
	for pkg in "${sortedExtraAur[@]}"; do
		status="OFF"
		[[ "$hasRunCustomSetup" == true ]] && [[ " ${customAurPackages[*]} " =~ " ${pkg} " ]] && status="ON"
		options+=("$pkg" "Extra" "$status")
	done
	
	local choices
	if choices=$(dialog --clear --no-lines --no-cancel --title "AUR Packages" --checklist "\nSelect AUR packages to install:" 40 60 10 "${options[@]}" 3>&1 1>&2 2>&3); then
		choices=$(printf "%s" "$choices" | tr -d '"')
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
	summaryText+="Install Zsh:     $( [[ "$customInstallZsh" == true ]] && printf "Yes" || printf "No" )\n"
	summaryText+="Copy Dotfiles:   $( [[ "$customInstallDotfiles" == true ]] && printf "Yes" || printf "No" )\n"
	summaryText+="Enable Services: $( [[ "$customEnableServices" == true ]] && printf "Yes" || printf "No" )\n\n"
	summaryText+="Do you want to confirm this configuration?"

	if dialog --clear --no-lines --title "Custom Installation Summary" --yes-label "Confirm" --no-label "Modify" --yesno "$summaryText" 18 60; then
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
		printf "%b Installation canceled by user.%b\n" "$FORMAT_ERROR" "$FORMAT_RESET"
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
		printf "\n%bFetching package lists from repository%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
	fi

	curl -sL "$PACKAGES_BASE_SOURCE" -o /tmp/drx-base.packages
	curl -sL "$PACKAGES_EXTRA_SOURCE" -o /tmp/drx-extra.packages

	source /tmp/drx-base.packages || exit 1
	source /tmp/drx-extra.packages || exit 1
}


function updateSystem() {
	printf "\n%bUpdating system%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
	sudo pacman -Syu --noconfirm
}


function installAurHelper() {
	if ! command -v yay &> /dev/null; then
		printf "\n%bInstalling YAY%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
		sudo pacman -S --needed --noconfirm git base-devel
		rm -rf /tmp/yay
		git clone https://aur.archlinux.org/yay.git /tmp/yay
		(cd /tmp/yay && makepkg -si --noconfirm)
	else
		printf "\n%b YAY is already installed.%b\n" "$FORMAT_SUCCESS" "$FORMAT_RESET"
	fi
}


function installBasePackages() {
	printf "\n%bInstalling Base Pacman Packages%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
	for pkg in "${base_pacman_packages[@]}"; do
		printf " %b->%b Installing %s...\n" "$FORMAT_INFO" "$FORMAT_RESET" "$pkg"
		sudo pacman -S --needed --noconfirm "$pkg"
	done

	if [[ "$installYay" == true ]]; then
		printf "\n%bInstalling Base AUR Packages%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
		for pkg in "${base_aur_packages[@]}"; do
			printf " %b->%b Installing %s (AUR)...\n" "$FORMAT_INFO" "$FORMAT_RESET" "$pkg"
			yay -S --needed --noconfirm "$pkg"
		done
	fi
}


function installExtraPackages() {
	printf "\n%bInstalling Extra Pacman Packages%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
	for pkg in "${extra_pacman_packages[@]}"; do
		printf " %b->%b Installing %s...\n" "$FORMAT_INFO" "$FORMAT_RESET" "$pkg"
		sudo pacman -S --needed --noconfirm "$pkg"
	done

	if [[ "$installYay" == true ]]; then
		printf "\n%bInstalling Extra AUR Packages%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
		for pkg in "${extra_aur_packages[@]}"; do
			printf " %b->%b Installing %s (AUR)...\n" "$FORMAT_INFO" "$FORMAT_RESET" "$pkg"
			yay -S --needed --noconfirm "$pkg"
		done
	fi
}


function installCustomPackagesList() {
	if [[ ${#customPacmanPackages[@]} -gt 0 ]]; then
		printf "\n%bInstalling Custom Pacman Packages%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
		for pkg in "${customPacmanPackages[@]}"; do
			printf " %b->%b Installing %s...\n" "$FORMAT_INFO" "$FORMAT_RESET" "$pkg"
			sudo pacman -S --needed --noconfirm "$pkg"
		done
	fi

	if [[ "$installYay" == true ]] && [[ ${#customAurPackages[@]} -gt 0 ]]; then
		printf "\n%bInstalling Custom AUR Packages%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
		for pkg in "${customAurPackages[@]}"; do
			printf " %b->%b Installing %s (AUR)...\n" "$FORMAT_INFO" "$FORMAT_RESET" "$pkg"
			yay -S --needed --noconfirm "$pkg"
		done
	fi
}


function installZshShell() {
	printf "\n%bInstalling and configuring ZSH%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
	sudo pacman -S --needed --noconfirm zsh
	sudo chsh -s /bin/zsh "$USER"
}


function copyDotfiles() {
	printf "\n%bCopying dotfiles%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
	# TODO: Copy all the configuration files to the correct directory
}


function enableSystemServices() {
	printf "\n%bEnabling System Services%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
	for service in "${SERVICES_TO_ENABLE[@]}"; do
		if sudo systemctl enable --now "${service}.service"; then
			printf "%b Service %s enabled%b\n" "$FORMAT_SUCCESS" "$service" "$FORMAT_RESET"
		fi
	done
}


function configureGraphicalEnvironment() {
	printf "\n%bConfiguring Graphical Environment%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
	# TODO: Installation and configurations of fonts and other graphical settings
}


function main() {
	if ! ping -c 1 -W 2 archlinux.org > /dev/null 2>&1; then
		printf "%b No internet connection detected. Terminating script%b\n" "$FORMAT_ERROR" "$FORMAT_RESET"
		exit 1
	fi

	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
	if ! command -v dialog &> /dev/null; then
		printf "%bInstalling dialog to display the UI%b\n" "$FORMAT_INFO" "$FORMAT_RESET"
		sudo pacman -S --noconfirm --needed dialog > /dev/null 2>&1
	fi

	local deps=("git" "wget" "unzip")
	local total=${#deps[@]}

	dialog --clear --title "Initial Setup" --gauge "\nChecking and installing missing dependencies..." 8 50 0 < <(
		for i in "${!deps[@]}"; do
			local pkg="${deps[$i]}"
			if ! command -v "$pkg" &> /dev/null; then
				sudo pacman -S --noconfirm --needed "$pkg" > /dev/null 2>&1
			fi
			local pct=$(( (i + 1) * 100 / total ))
			printf "%s\n" "$pct"
		done
	)

	runConfigurationUi

	printf "%bStarting execution phase%b\n" "$FORMAT_INFO" "$FORMAT_RESET"

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

	# TODO: Go directory delete if created during execution
	# TODO: Make a log file for package instalattion errors and other errors during execution

	printf "\n%b The script has finished running. Enjoy your system! :)%b\n" "$FORMAT_SUCCESS" "$FORMAT_RESET"
}

main "$@"
