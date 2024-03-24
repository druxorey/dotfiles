#!/bin/bash

TITLE="\e[1;35m"
RUNNING="\e[35m"
QUESTION="\e[36m"
SUCCESS="\e[1;32m"
FAILED="\e[1;31m"
END="\e[0m"
LINE="\n"

# Each of the commands that can be executed to install a package or service
pacman_packages_installation="sudo pacman -S --noconfirm"
yay_packages_installation="yay -S --noconfirm"
service_installation="sudo systemctl enable"

# Categories of installable Pacman packages
base_pacman_packages_list=(xorg bspwm sxhkd lxappearance picom nitrogen kitty lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings networkmanager reflector libinput timeshift)

utils_pacman_packages_list=(lsd scrot rofi cmus neovim unzip p7zip unrar tar rsync htop exfat-utils fuse-exfat curl wget trash-cli ranger thefuck tldr gnome-keyring usbutils bash-completion neofetch vim git bat btop speedtest-cli imagemagick exa tmux sxiv ncdu fzf cmatrix zip alsa-utils php nodejs npm translate-shell xsel ripgrep fd the_silver_searcher)

drivers_pacman_packages_list=(blueman bluez-utils pulseaudio-bluetooth brightnessctl tumbler gvfs-smb samba smbclient hplip cups cups-pdf system-config-printer jdk-openjdk flatpak redshift)

gui_pacman_packages_list=(gedit thunar nautilus dmenu vlc polybar libreoffice-fresh gimp pdfarranger steam)

# Installable Yay packages
yay_packages_list=(visual-studio-code-bin notion-app-electron microsoft-edge-dev-bin brave-bin peaclock cava pipes.sh tetris-terminal-git minecraft-launcher gtypist)

# Habilitable services
services_list=(cups NetworkManager lightdm bluetooth.service)


# ====================== Functions ====================== #


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
        $command_executor $item
        if [ $? -eq 0 ]; then
            echo -e "${SUCCESS}The $item_type has been installed correctly${END}"
        else
            echo -e "${FAILED}!!!!WARNING!!!! The following $item_type could not be installed: ${END}$item"
        fi
    done
}


ask_user() {
    local question_text="$1"
    local action="$2"


    echo -ne "${LINE}${QUESTION}${question_text} (Y/n): ${END}"
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
        echo -e "${FAILED}!!!!WARNING!!!! The installation will not be executed${END}"
    fi
}


# ====================== Main code ====================== #

echo -e "${LINE}${TITLE} ========== Welcome to the Arch Linux bootstrap ========== ${END}${LINE}"

echo -e "First we will have to update the system to be able to ensure that there are no problems in the installation"
ask_user "Do you wanna update your system?" "sudo pacman -Syu"

pacman_package_categories=("base" "utils" "drivers" "gui")

for category in "${pacman_package_categories[@]}"; do
    install_command="${category}_pacman_packages_list[@]"
    echo -e "${LINE}${RUNNING}The next pacman packages will be installing:${END} $(eval echo \${$install_command})"
    ask_user "Do you want to install them?" "execute_command \"pacman\" \"\${$install_command}\""
done

yay_install_commands='cd && git clone https://aur.archlinux.org/yay.git; cd yay/ && makepkg -si; cd .. && sudo rm -r yay'
ask_user "Do you want to install yay?" "$yay_install_commands"

yay_packages_install_commands='execute_command "yay" "${yay_packages_list[@]}"'
echo -e "${LINE}${RUNNING}The next packages will be installing:${END} ${yay_packages_list[@]}"
ask_user "Do you want to install them?" "$yay_packages_install_commands" 

service_install_commands='execute_command "service" "${services_list[@]}"'
ask_user "Do you want to enable the services?" "$service_install_commands" 

zsh_install_commands='sudo pacman -S zsh; chsh -s /bin/zsh'
ask_user "Do you want to install zsh and make it your default shell?" "$zsh_install_commands"

echo -e "${LINE}${TITLE} The script has finished running, enjoy your system :) ${END}"
echo -e "${TITLE} Made by: github.com/druxorey${END}${LINE}"
