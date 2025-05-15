#!/bin/bash

ERROR="\e[1;91m"
SUCCESS="\e[1;92m"
END="\e[0m"

DOTFILES_DIR="$HOME/Workspace/Projects/dotfiles"
OBSIDIAN_DIR="$HOME/Documents/'[01] Obsidian'"

function main() {

	commandList=(
	"rsync -a --delete ~/.config/autorandr $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/bspwm $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/cmus $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/dunst $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/fastfetch $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/flameshot $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/kitty $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/nvim $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/oh-my-posh $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/picom $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/polybar $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/rofi $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/sxhkd $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/tmux $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/yazi $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/Vencord/ $DOTFILES_DIR/config/vencord"
	"rsync -a --delete ~/.config/zsh $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/zathura $DOTFILES_DIR/config"
	"rsync -a --delete ~/Workspace/Scripts/ $DOTFILES_DIR/scripts"
	"rsync -a --delete $OBSIDIAN_DIR/Academic/.obsidian/* $DOTFILES_DIR/config/obsidian"
	"rsync -a ~/.zshrc $DOTFILES_DIR/config/zshrc"
	"rsync -a ~/.bashrc $DOTFILES_DIR/config/bashrc"
	"rsync -a ~/.config/libinput-gestures.conf $DOTFILES_DIR/config/touchpad-gestures"
	"rsync -a /etc/tlp.d/ $DOTFILES_DIR/config/tlp"
	"rsync -a /etc/X11/xorg.conf.d/40-libinput.conf $DOTFILES_DIR/config/touchpad-configuration"
	"rsync -a /var/spool/cron/druxorey $DOTFILES_DIR/config/crontab"
	)

	for command in "${commandList[@]}"; do
		eval $command
		if [ $? -ne 0 ]; then
			echo -e "\n$ERROR ⚠ Error: Unexpected interruption during backup. Please try again$END\n"
			exit 1
		fi
	done

	scriptsDir=$DOTFILES_DIR/scripts
	scripts=$(ls $DOTFILES_DIR/scripts/ -p | grep -v /)

	for i in $scripts; do
		chmod -x $scriptsDir/$i || {
			echo -e "\n$ERROR ⚠ Error: Unable to change permissions of $i. Please check the file$END\n"
			exit 1
		}
		mv $scriptsDir/$i $scriptsDir/$i.sh || {
			echo -e "\n$ERROR ⚠ Error: Unable to rename $i. Please check the file$END\n"
			exit 1
		}
	done

	echo -e "${SUCCESS}All files have been successfully backed up$END"
}

main $@
