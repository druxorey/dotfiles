#!/bin/bash

TITLE="\e[1;34m"
ERROR="\e[1;91m"
SUCCESS="\e[1;92m"
END="\e[0m"

OBSIDIAN_DIR="$HOME/Documents/'[01] Obsidian'"
EXCLUDE="--exclude=.git/ --exclude=.github --exclude=*.gitmodules --exclude=*.editorconfig --exclude=*.gitignore"

function help() {
	printf "
${TITLE}USAGE:$END
    dotbak.sh DIRECTORY

${TITLE}DESCRIPTION:$END
    This script creates a backup of various system files and configurations
    to the specified directory. It uses rsync to synchronize important
    directories and files, ensuring they remain up-to-date.

${TITLE}ARGUMENTS:$END
    DIRECTORY             The target directory where the backup will be stored.

${TITLE}EXAMPLES:$END
    dotbak.sh /path/to/backup

${TITLE}REPORTING BUGS:$END
    Report issues at: https://github.com/druxorey/dotfiles/issues

"
	exit 1
}


function main() {
	local directory="$1"

	while getopts "h" opt; do
		case $opt in
			h) help ;;
		esac
	done

	if [ -z "$directory" ]; then
		printf "${ERROR} ⚠ [ERROR]: No directory specified. Please provide a target directory.$END\n"
		exit 1
	fi

	mkdir -p "$directory/config" "$directory/local"

	declare -A commandList=(
		["~/.config/autorandr"]="rsync -a --delete ~/.config/autorandr $directory/config"
		["~/.config/bspwm"]="rsync -a --delete ~/.config/bspwm $directory/config"
		["~/.config/cmus"]="rsync -a --delete ~/.config/cmus $directory/config"
		["~/.config/dunst"]="rsync -a --delete ~/.config/dunst $directory/config"
		["~/.config/fastfetch"]="rsync -a --delete ~/.config/fastfetch $directory/config"
		["~/.config/flameshot"]="rsync -a --delete ~/.config/flameshot $directory/config"
		["~/.config/kitty"]="rsync -a --delete ~/.config/kitty $directory/config"
		["~/.config/neovim"]="rsync -a --delete ~/.config/nvim $directory/config"
		["~/.config/oh-my-posh"]="rsync -a --delete ~/.config/oh-my-posh $directory/config"
		["~/.config/picom"]="rsync -a --delete ~/.config/picom $directory/config"
		["~/.config/polybar"]="rsync -a --delete ~/.config/polybar $directory/config"
		["~/.config/rofi"]="rsync -a --delete ~/.config/rofi $directory/config"
		["~/.config/sxhkd"]="rsync -a --delete ~/.config/sxhkd $directory/config"
		["~/.config/tmux"]="rsync -a --delete $EXCLUDE ~/.config/tmux $directory/config"
		["~/.config/yazi"]="rsync -a --delete ~/.config/yazi $directory/config"
		["~/.config/vencord"]="rsync -a --delete ~/.config/Vencord/ $directory/config/vencord"
		["~/.config/zsh"]="rsync -a --delete $EXCLUDE ~/.config/zsh $directory/config"
		["~/.config/zathura"]="rsync -a --delete ~/.config/zathura $directory/config"
		["~/.config/libinput-gestures.conf"]="rsync -a ~/.config/libinput-gestures.conf $directory/config/touchpad/"
		["~/.zshrc"]="rsync -a ~/.zshrc $directory/config/zshrc"
		["~/.bashrc"]="rsync -a ~/.bashrc $directory/config/bashrc"
		["~/.local/bin"]="rsync -a --delete ~/.local/bin $directory/local/"
		["~/.local/share/applications"]="rsync -a --delete ~/.local/share/applications $directory/local/share/"
		["$OBSIDIAN_DIR/Academic/.obsidian"]="rsync -a --delete $OBSIDIAN_DIR/Academic/.obsidian/* $directory/config/obsidian"
		["/etc/X11/xorg.conf.d/40-libinput.conf"]="rsync -a /etc/X11/xorg.conf.d/40-libinput.conf $directory/config/touchpad/"
		["/etc/tlp.d"]="rsync -a /etc/tlp.d/ $directory/config/tlp"
		["/var/spool/cron/druxorey"]="rsync -a /var/spool/cron/druxorey $directory/config/crontab"
	)

	for name in "${!commandList[@]}"; do
		command="${commandList[$name]}"
		eval $command
		if [ $? -ne 0 ]; then
			printf "\n$ERROR ⚠ [ERROR]: Unexpected interruption during (%s) backup.$END\n\n" "$name"
			exit 1
		fi
		printf "${SUCCESS} ✔ Successfully backed up:$END %s\n" "$name"
	done

	echo -e "\n${SUCCESS}All files have been successfully backed up$END"
}

main $@
