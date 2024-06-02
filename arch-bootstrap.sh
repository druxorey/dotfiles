#!/bin/bash

TITLE="\e[1;35m"
RUNNING="\e[35m"
QUESTION="\e[36m"
SUCCESS="\e[1;32m"
FAILED="\e[1;31m"
END="\e[0m"
LINE="\n"


basePacmanList=(bspwm git kitty libinput lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lxappearance networkmanager nitrogen picom polybar reflector sxhkd timeshift ufw xorg)

utilsPacmanList=(bash-completion bat btop cmatrix cmus curl exa exfat-utils fastfetch fd flatpak fuse-exfat fzf github-cli gnome-keyring hugo imagemagick ncdu neovim nodejs npm p7zip php ranger redshift ripgrep rofi rsync rust scrot sl speedtest-cli sxiv tar the_silver_searcher thefuck tldr tmux translate-shell trash-cli unrar unzip usbutils vim viu wget xsel yt-dlp zip zoxide zathura zathura-pdf-mupdf)

driversPacmanList=(alsa-utils blueman bluez-utils brightnessctl cups cups-pdf gvfs-smb hplip jdk-openjdk linux-headers noto-fonts noto-fonts-cjk noto-fonts-emoji ntfs-3g papirus-icon-theme pulseaudio-bluetooth python-pip python-setuptools python-virtualenv samba smbclient system-config-printer tumbler)

guiPacmanList=(code discord gedit gimp gloobus-preview gthumb libreoffice-fresh nautilus obsidian sigil steam thunar virtualbox vlc)

yayPackagesList=(ani-cli brave-bin cava googler gtypist microsoft-edge-dev-bin minecraft-launcher notion-app-electron obs-studio oh-my-posh peaclock pipes.sh tetris-terminal-git tumbler-extra-thumbnailers)

servicesList=(ufw.service cups NetworkManager lightdm bluetooth.service)


installPackage() {
    pacmanPackageInstallation="sudo pacman -S --noconfirm"
    yayPackageInstallation="yay -S --noconfirm"

    local packageManager="$1"
    shift

    if [ "$packageManager" == "pacman" ]; then
        commandExecutor="$pacmanPackageInstallation"
    elif [ "$packageManager" == "yay" ]; then
        commandExecutor="$yayPackageInstallation"
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

enableService() {
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


askUser() {
    local questionText="$1"
    local action="$2"

    echo -ne "${LINE}${QUESTION}${questionText} (Y/n): ${END}"
    read -r output
    echo ""

    output=${output,,}

    if [[ -z $output ]]; then
        output='y'
    fi

    if [[ $output == 'y' ]]; then
        echo -e "${QUESTION}The installation will begin${END}"
        eval "$action"
    else
        echo -e "${FAILED} !WARNING! The installation will not be executed${END}"
    fi
}


function main() {
    echo -e "${LINE}${TITLE} [========== WELCOME TO DRUXOREY'S ARCH LINUX BOOTSTRAP ==========] ${END}${LINE}"

    sysUpdate="sudo pacman -Syu"
    echo -e "First we will have to update the system to be able to ensure that there are no problems in the installation"
    askUser " ► Do you wanna update your system?" "$sysUpdate" 

    pacmanCategories=("base" "utils" "drivers" "gui")
    for category in "${pacmanCategories[@]}"; do
        pacmanPkgInstallCommand="installPackage "pacman" "\${${category}PacmanList[@]}""
        echo -e "${LINE}${RUNNING}The next pacman packages will be installing:${END} $(eval echo \${${category}PacmanList[@]})"
        askUser " ► Do you want to install them?" "$pacmanPkgInstallCommand"
    done

    yayInstallCommand="cd && git clone https://aur.archlinux.org/yay.git; cd yay/ && makepkg -si; cd .. && sudo rm -r yay"
    askUser "Do you want to install yay?" "$yayInstallCommand"

    yayPkgInstallCommand="installPackage "yay" "${yayPackagesList[@]}""
    echo -e "${LINE}${RUNNING}The next packages will be installing:${END} ${yayPackagesList[@]}"
    askUser "Do you want to install them?" "$yayPkgInstallCommand" 

    serviceInstallCommand="enableService "${servicesList[@]}""
    askUser "Do you want to enable the services?" "$serviceInstallCommand" 

    zshInstallCommand="sudo pacman -S zsh; chsh -s /bin/zsh"
    askUser "Do you want to install zsh and make it your default shell?" "$zshInstallCommand"

    echo -e "${LINE}${TITLE} The script has finished running, enjoy your system :) ${END}"
    echo -e "${TITLE} Made by: github.com/druxorey${END}${LINE}"
}

main $@
