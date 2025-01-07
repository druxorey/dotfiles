#!/bin/bash

. $(dirname $0)/lib/shload.sh

ERROR="\e[1;91m"
SUCCESS="\e[1;92m"
END="\e[0m"

DOTFILES_DIR=~/Workspace/dotfiles

function main() {

	commandList=(
	"rsync -a --delete ~/.config/bspwm $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/sxhkd $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/kitty $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/fastfetch $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/tmux $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/oh-my-posh $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/picom $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/polybar $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/rofi $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/nvim $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/autorandr $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/yazi $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/cmus $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/zsh $DOTFILES_DIR/config"
	"rsync -a --delete ~/.config/Vencord/ $DOTFILES_DIR/config/vencord"
	"rsync -a --delete ~/.config/dunst/ $DOTFILES_DIR/config/dunst"
	"rsync -a --delete --exclude '_test' --exclude 'custom' ~/.config/bin/ $DOTFILES_DIR/scripts"
	"rsync -a --delete ~/Documents/Obsidian/Academic/.obsidian/* $DOTFILES_DIR/config/obsidian"
	"rsync -a ~/.zshrc $DOTFILES_DIR/config/zshrc"
	"rsync -a ~/.bashrc $DOTFILES_DIR/config/bashrc"
	"rsync -a ~/.config/libinput-gestures.conf $DOTFILES_DIR/config/touchpad-gestures"
	"rsync -a /etc/X11/xorg.conf.d/40-libunput.conf $DOTFILES_DIR/config/touchpad-configuration"
	)

	setupShload ${#commandList[@]} "Progress"
	count=0

	for command in "${commandList[@]}"; do
		count=$(($count + 1))
		eval $command

		if [ $? -ne 0 ]; then
			echo -e "\n$ERROR ⚠ Error: Unexpected interruption during backup. Please try again$END\n"
			exit 1
		fi

		updateShload $count
	done

	scripts=$(ls $DOTFILES_DIR/scripts/ -p | grep -v /)
	scriptsDir=$DOTFILES_DIR/scripts

	for i in $scripts; do
		chmod -x $scriptsDir/$i
		mv $scriptsDir/$i $scriptsDir/$i.sh
	done

	echo -e "\n${SUCCESS}All files have been successfully backed up$END"
}

main $@
