#!/bin/bash

RUNNING="\e[35m"
FAILED="\e[1;31m"
END="\e[0m"

paquetes=("git" "vim" "smbclient" "samba" "virtualbox-guest-utils" "xf86-video-vmware" "linux-headers" "linux-lts-headers" "linux-lts")

function main() {

	echo -e "$RUNNING Initializing system... $END"
	sudo pacman -S --noconfirm ${paquetes[@]} || echo -e "$FAILED System initialization failed$END"

	echo -e "$RUNNING Cloning dotfiles... $END"
	git clone https://github.com/druxorey/dotfiles.git ~/dotfiles || echo -e "$FAILED Cloning failed$END"

	sudo mkdir /etc/samba
	sudo wget -O /etc/samba/smb.conf "https://raw.githubusercontent.com/samba-team/samba/master/examples/smb.conf.default"

	sudo systemctl enable smb.service
	sudo systemctl start smb.service
	sudo systemctl enable nmb.service
	sudo systemctl start nmb.service

	echo -e "$RUNNING Setting aliases... $END"
	echo -e "Enter the server's ip: "
	read ipServer
	echo "Enter the server's username: "
	read usernameServer
	echo "Enter the server's password: "
	read passwordServer

	echo "alias buho='smbclient //$ipServer -U $usernameServer%$passwordServer'" >> ~/.bashrc

	source ~/.bashrc
}

main $@
