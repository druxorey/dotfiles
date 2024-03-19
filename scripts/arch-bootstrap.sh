#!/bin/bash

TITLE="\e[1;35m"
RUNNING="\e[35m"
QUESTION="\e[36m"
SUCCESS="\e[1;32m"
FAILED="\e[1;31m"
END="\e[0m"
LINE="\n"

pacman_packages_installation="sudo pacman -S --noconfirm"
yay_packages_installation="yay -S --noconfirm"
service_installation="sudo systemctl enable"

pacman_packages_list=(xorg bspwm sxhkd lxappearance picom nitrogen kitty lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings networkmanager reflector libinput timeshift blueman bluez-utils pulseaudio-bluetooth brightnessctl lsd scrot rofi cmus neovim gedit unzip p7zip unrar tar rsync htop exfat-utils fuse-exfat curl wget trash-cli ranger thefuck tldr gnome-keyring usbutils gthumb bash-completion neofetch vim git bat btop speedtest-cli imagemagick exa tmux sxiv ncdu fzf cmatrix zip alsa-utils tumbler gvfs-smb samba smbclient hplip cups cups-pdf system-config-printer thunar nautilus dmenu vlc polybar libreoffice-fresh gimp jdk-openjdk flatpak pdfarranger steam php redshift nodejs npm translate-shell xsel ripgrep fd the_silver_searcher)

yay_packages_list=(visual-studio-code-bin notion-app-electron microsoft-edge-dev-bin brave-bin peaclock cava pipes.sh tetris-terminal-git minecraft-launcher gtypist)

services_list=(cups NetworkManager lightdm bluetooth.service)


execute_command() {
    local command_type="$1"
    shift

    if [ "$command_type" == "pacman" ]; then
        command_executor="$pacman_packages_installation"
        item_type="package"
    elif [ "$command_type" == "yay" ]; then
        command_executor="$yay_packages_installation"
        item_type="package"
    elif [ "$command_type" == "service" ]; then
        command_executor="$service_installation"
        item_type="service"
    fi

    for item in "${@}"; do
        echo -e "${RUNNING}Installing ${END}$item"
        echo -e $command_executor $item
        if [ $? -eq 0 ]; then
            echo -e "${SUCCESS}The $item_type has been installed correctly${END}"
        else
            echo -e "${FAILED}ERROR ALERT! The following $item_type could not be installed: ${END}$item"
        fi
    done
}


ask_user() {
    local question="$1"
    local action="$2"

    echo -ne "${QUESTION}${question} (Y/n): ${END}"
    read -r output

    output=${output,,}

    if [[ -z $output ]]; then
        output='y'
    fi

    if [[ $output == 'y' ]]; then
        eval "$action"
    else
        echo -e "${FAILED}La acción no se ejecutará${END}"
    fi
}


echo -e "${LINE}${TITLE}Welcome to the pacman and yay package installer!${LINE}${END}"

echo -e "${QUESTION}The installation of the Pacman packages will begin${END}"
ask_user "¿Do you want to install the pacman packages?" 'execute_command "pacman" "${pacman_packages_list[@]}"'

yay_install_commands='cd && git clone https://aur.archlinux.org/yay.git; cd yay/ && makepkg -si; cd .. && sudo rm -r yay'
ask_user "¿Do you want to install yay?" "$yay_install_commands"

echo -e "${QUESTION}The installation of the Yay packages will begin${END}"
ask_user "¿Do you want to install the pacman packages?" 'execute_command "yay" "${yay_packages_list[@]}"'

ask_user "¿Do you want to enable the services?" 'execute_command "service" "${services_list[@]}"'

zsh_install_commands='sudo pacman -S zsh; chsh -s /bin/zsh'
ask_user "¿Do you want to install zsh and make it your default shell?" "$zsh_install_commands"
