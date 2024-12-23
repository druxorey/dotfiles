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
    echo "             of an Arch Linux system. It updates the system, installs essential packages"
    echo "             (both from Pacman and AUR), and enables necessary services like the firewall"
    echo "             and the login manager. It’s particularly useful for users who want a quick and"
    echo "             straightforward installation process."
    echo
    echo "OPTIONS:"
    echo "  -h      Shows this help."
    echo "  -a      Automated mode. The script will not ask for user confirmation."
    echo
    echo "Report bugs to https://github.com/druxorey/dotfiles"
    echo
    exit 1
}


function initialize() {
    test -f arch-packages.sh || wget -O arch-packages.sh https://raw.githubusercontent.com/druxorey/dotfiles/master/arch-packages.sh
    source "$(dirname "$0")/arch-packages.sh"
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

    if $gitClone; then
        sudo pacman -S --noconfirm rsync
        rsync -av --delete $dotfilesPath/config/* $HOME/.config/
        mv -f $HOME/.config/zshrc $HOME/.zshrc
        mv -f $HOME/.config/bashrc $HOME/.bashrc
        rm -rf $dotfilesPath/
        echo -e "${SUCCESS}The dotfiles have been cloned correctly${END}"
    else
        echo -e "${FAILED} !WARNING! The dotfiles could not be cloned"
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

    pacmanCategories=("base" "utils" "drivers" "gui")
    for category in "${pacmanCategories[@]}"; do
        installCommand="installPackage "pacman" "\${${category}PacmanList[@]}""
        echo -e "${LINE}${RUNNING}The next pacman packages will be installing:${END} $(eval echo \${${category}PacmanList[@]})"
        askUser "► Proceed with the installation?" "$installCommand"
    done

    installCommand="cd && git clone https://aur.archlinux.org/yay.git && cd yay/ && makepkg -si && cd .. && sudo rm -r yay/"
    askUser "► Do you want to install yay?" "$installCommand"

    installCommand='installPackage "yay" "${yayPackagesList[@]}"'
    echo -e "${LINE}${RUNNING}The next packages will be installing:${END} ${yayPackagesList[@]}"
    askUser "► Proceed with the installation?" "$installCommand"

    installCommand='enableService "${servicesList[@]}"'
    askUser "► Proceed enabling the services?" "$installCommand"

    installCommand='sudo pacman -S --noconfirm zsh && chsh -s /bin/zsh'
    askUser "► Proceed installing zsh and make it the default shell?" "$installCommand"

    echo -e "${FAILED} ⚠ !WARNING THE NEXT COMMAND WILL OVERRIDE EXISTING FILES!${END}"
    askUser "► Proceed copying the dotfiles?" "copyDotfiles"

    clear

    echo -e "${LINE}${TITLE} The script has finished running, enjoy your system :) ${END}"
    echo -e "${TITLE} Made by: github.com/druxorey${END}${LINE}"
}

main $@
