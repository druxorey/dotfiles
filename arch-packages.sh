#!/bin/bash

core_Packages=(bspwm git kitty libinput lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings networkmanager reflector sxhkd timeshift ufw xorg)

essential_Packages=(bash-completion bat btop curl exfat-utils eza fastfetch fd ffmpeg fuse-exfat fzf gnome-keyring imagemagick ncdu neovim p7zip pv ripgrep rsync scrot silicon sl speedtest-cli sxiv tar the_silver_searcher thefuck tldr tmux tokei translate-shell trash-cli unrar unzip usbutils vim wget xclip xdg-ninja xsel yazi zip zoxide)

utils_Packages=(cmatrix cmus github-cli viu yt-dlp)

drivers_Packages=(alsa-utils autorandr blueman bluez-utils brightnessctl cups cups-pdf ffmpegthumbnailer g++ gestures gvfs-mtp gvfs-smb hplip jdk-openjdk linux-headers mtpfs ncurses nodejs npm ntfs-3g pandoc-cli php pulseaudio-bluetooth python-pip python-setuptools python-virtualenv redshift rust samba simple-scan smbclient system-config-printer tlp tumbler flatpak)

customization_Packages=(lxappearance nitrogen noto-fonts noto-fonts-cjk noto-fonts-emoji papirus-icon-theme picom polybar)

gui_Packages=(code discord gedit gimp gloobus-preview gthumb libreoffice-fresh nautilus obs-studio obsidian rofi rofi-calc sigil steam thunar transmission-gtk vbam-wx virtualbox vlc wine zathura zathura-pdf-mupdf)

terminal_AurPackages=(ani-cli cava googler gtypist manga-cli-git oh-my-posh peaclock pipes.sh tetris-terminal-git tumbler-extra-thumbnailers)

gui_AurPackages=(brave-bin deemix-gui-git minecraft-launcher notion-app-electron proton-vpn-gtk-app)

drivers_Services=(ufw.service cups NetworkManager lightdm bluetooth.service)
