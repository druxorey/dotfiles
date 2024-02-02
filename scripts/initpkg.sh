#!/bin/bash

packages_pacman=(xorg bspwm sxhkd lxappearance picom nitrogen kitty lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings reflector libinput timeshift blueman bluez-utils pulseaudio-bluetooth brightnessctl lsd scrot rofi cmus neovim gedit unzip p7zip unrar tar rsync htop exfat-utils fuse-exfat curl wget trash-cli ranger thefuck tldr gnome-keyring usbutils gthumb bash-completion neofetch vim git bat btop speedtest-cli imagemagick exa tmux sxiv ncdu fzf cmatrix zip alsa-utils tumbler gvfs-smb samba samba-client hplip cups cups-pdf system-config-printerbas thunar nautilus dmenu vlc polybar libreoffice-fresh gimp jdk-openjdk flatpak pdfarranger steam libreoffice-fresh php)

packages_yay=(visual-studio-code-bin notion-app-electron microsoft-edge-dev-bin brave-bin peaclock cava pipes.sh tetris-terminal-git minecraft-launcher)

echo -e "\e[1m !Wellcome to the bash installer!"

echo -e "\e[33m Installing packages with pacman..."
for package in ${packages_pacman[@]}; do
    echo -e "\e[33m Installing $package..."
    sudo pacman -S --noconfirm $package
done

cd && git clone https://aur.archlinux.org/yay.git
cd yay/ && makepkg -si
cd .. && sudo rm -r yay/

echo -e "\e[33m Installing packages with yay..."
for package in ${packages_yay[@]}; do
    echo "Installing $package..."
    yay -S --noconfirm $package
done

echo -e "\e[33m Enabling Services..."

sudo systemctl enable --now cups
