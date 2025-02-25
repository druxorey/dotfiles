#!/bin/bash

core_Packages=(bspwm dunst git kitty libinput libinput-gestures lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings linux linux-firmware linux-headers networkmanager reflector sxhkd timeshift ufw xorg)

essential_Packages=(bash-completion bat btop curl dosfstools exfat-utils eza fastfetch fd ffmpeg fuse-exfat fzf gnome-keyring imagemagick ncdu neovim p7zip pv ripgrep rsync scrot silicon sl speedtest-cli sxiv tar the_silver_searcher thefuck tldr tmux tokei translate-shell trash-cli unrar unzip usbutils vim wget xclip xdg-ninja xsel yazi zip zoxide)

utils_Packages=(cmatrix cmus dialog genact github-cli gping viu yt-dlp)

drivers_Packages=(alsa-utils autorandr blueman bluez-utils brightnessctl bsp-layout cpufetch cups cups-pdf ffmpegthumbnailer g++ gestures gvfs-mtp gvfs-smb hplip iniparser intel-ucode jdk-openjdk luarocks mtpfs ncurses nodejs npm ntfs-3g pandoc-cli php pulseaudio-bluetooth python python-black python-pip python-setuptools python-virtualenv redshift rust rust-analyzer sane samba simple-scan smbclient system-config-printer texlive-bin texlive-bibtexextra texlive-binextra texlive-fontsextra texlive-fontsrecommended texlive-langspanish texlive-latex texlive-latexextra texlive-latexrecommended texlive-mathscience texlive-pictures texlive-xetex tlp tumbler upower xdotool)

customization_Packages=(lxappearance nitrogen noto-fonts noto-fonts-cjk noto-fonts-emoji papirus-icon-theme picom polybar)

gui_Packages=(code discord gimp gloobus-preview gthumb inkscape libreoffice-fresh nautilus obs-studio obsidian qalculate-gtk rofi rofi-calc sigil steam thunar transmission-gtk vbam-wx virtualbox vlc wine zathura zathura-pdf-mupdf)

terminal_AurPackages=(ani-cli cava googler gtypist manga-cli-git oh-my-posh peaclock pipes.sh tetris-terminal-git tumbler-extra-thumbnailers)

gui_AurPackages=(brave-bin deemix-gui-git minecraft-launcher notion-app-electron proton-vpn-gtk-app)

drivers_Services=(ufw.service cups NetworkManager lightdm bluetooth.service)