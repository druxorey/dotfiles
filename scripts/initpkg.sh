#!/bin/bash

#* Colors for the prompts

TITLE="\e[1;35m"
RUNNING="\e[35m"
QUESTION="\e[36m"
SUCCESS="\e[1;32m"
FAILED="\e[1;31m"
END="\e[0m"
LINE="\n"

#* List of packages to install

pacman_packages=(xorg bspwm sxhkd lxappearance picom nitrogen kitty lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings reflector libinput timeshift blueman bluez-utils pulseaudio-bluetooth brightnessctl lsd scrot rofi cmus neovim gedit unzip p7zip unrar tar rsync htop exfat-utils fuse-exfat curl wget trash-cli ranger thefuck tldr gnome-keyring usbutils gthumb bash-completion neofetch vim git bat btop speedtest-cli imagemagick exa tmux sxiv ncdu fzf cmatrix zip alsa-utils tumbler gvfs-smb samba samba-client hplip cups cups-pdf system-config-printerbas thunar nautilus dmenu vlc polybar libreoffice-fresh gimp jdk-openjdk flatpak pdfarranger steam php redshift nodejs npm translate-shell)

yay_packages=(visual-studio-code-bin notion-app-electron microsoft-edge-dev-bin brave-bin peaclock cava pipes.sh tetris-terminal-git minecraft-launcher)

services=(cups NetworkManager lightdm bluetooth.service)

#* Instalation of the pacman packages

echo -e "${LINE}${TITLE}Welcome to the pacman and yay package installer!${LINE}${END}"
echo -e "${QUESTION}The installation of the Pacman packages will begin${END}"

for package in ${pacman_packages[@]}; do
    echo -e "${RUNNING}Installing ${END}$package"
    sudo pacman -S --noconfirm $package

    if [ $? -eq 0 ]
    then
    	echo -e "${SUCCESS}Installed the correctly${END}"
    else
    	echo -e "${FAILED}!!!ERROR ALERT!!! The following package could not be installed: ${END}$package"
    fi
done

#* Instalation of yay

echo -e "${QUESTION}¿Do you want to install yay? (Y/n)${END}"
read -r output

output=${output,,}

if [[ -z $output ]]; then
  output='y'
fi

if [[ $output == 'y' ]]; then
    cd && git clone https://aur.archlinux.org/yay.git
    cd yay/ && makepkg -si
    cd .. && sudo rm -r yay
else
	echo -e "${FAILED}Yay will not be installed${END}"
fi

#* Instalation of yay packages

echo -e "${QUESTION}The installation of the Yay packages will begin${END}"

for package in ${yay_packages[@]}; do
    echo -e "${RUNNING}Installing ${END}$package"
    yay -S --noconfirm $package

    if [ $? -eq 0 ]
    then
    	echo -e "${SUCCESS}Installed the correctly${END}"
    else
    	echo -e "${FAILED}!!!ERROR ALERT!!! The following package could not be installed: ${END}$package"
    fi
done

#* Enabling Services 

echo -e "${QUESTION}¿Do you want to enable the services? (Y/n)${END}"
read -r output

output=${output,,}

if [[ -z $output ]]; then
  output='y'
fi

if [[ $output == 'y' ]]; then

	echo -e "${RUNNING}Enabling Services${END}"
	for service in ${services[@]}; do
		echo -e "${RUNNING}Enabling ${END}$service"
		sudo systemctl enable --now $service
	done
fi
	
else
	echo -e "${FAILED}!!WARNING!! The services are not enabled, if you need them please install and enable manually, we recommend enabling the services for a good experience${END}"
fi

#* Installing zsh shell

echo -e "${QUESTION}¿Do you want to install zsh and make it your default shell? (Y/n)${END}"
read -r output

output=${output,,}

if [[ -z $output ]]; then
  output='y'
fi

if [[ $output == 'y' ]]; then

	echo -e "${RUNNING}Installing zsh${END}"
	sudo pacman -S zsh
  chsh -s /bin/zsh
	done
fi
	
else
  echo -e "${FAILED}!!WARNING!! The services are not enabled, if you need them please install and enable manually, we recommend enabling the services for a good experience${END}"
fi
