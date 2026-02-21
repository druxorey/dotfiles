#!/bin/bash

TITLE="\e[1;34m"
ERROR="\e[1;91m"
SUCCESS="\e[1;92m"
END="\e[0m"

OBSIDIAN_DIR="$HOME/Documents/'A1 Obsidian'"
EXCLUDE="--exclude=.git/ --exclude=.github --exclude=*.gitmodules --exclude=*.editorconfig --exclude=*.gitignore"
BOOKMARKS_DIR="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
YAML_DIR="$HOME/Workspace/Projects/dotfiles/config/brave/"

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


function backupBookmarks() {
    grep -E '"name":|\"url\":' "$BOOKMARKS_DIR" | awk '
    BEGIN { name = ""; url = ""; }
    /"name":/ {
        name = $0;
        getline;
        if ($0 ~ /"url":/) {
            url = $0;
            print "- name: " substr(name, index(name, ":") + 3, length(name) - index(name, ":") - 4) "\n  url: " substr(url, index(url, ":") + 3, length(url) - index(url, ":") - 3);
        }
    }
    ' > "$YAML_DIR/bookmarks.yaml"
}


function main() {
	local directory="$1"

	while getopts "h" opt; do
		case $opt in
			h) help ;;
			*) help ;;
		esac
	done

	if [ -z "$directory" ]; then
		printf "${ERROR} ⚠ [ERROR]: No directory specified. Please provide a target directory.$END\n"
		exit 1
	fi

	mkdir -p "$directory/config" "$directory/local"

	declare -A commandList=(
		["$HOME/.config/autorandr"]="rsync -a --delete $HOME/.config/autorandr $directory/config"
		["$HOME/.config/bspwm"]="rsync -a --delete $HOME/.config/bspwm $directory/config"
		["$HOME/.config/cmus"]="rsync -a --delete $HOME/.config/cmus $directory/config"
		["$HOME/.config/dunst"]="rsync -a --delete $HOME/.config/dunst $directory/config"
		["$HOME/.config/fastfetch"]="rsync -a --delete $HOME/.config/fastfetch $directory/config"
		["$HOME/.config/flameshot"]="rsync -a --delete $HOME/.config/flameshot $directory/config"
		["$HOME/.config/kitty"]="rsync -a --delete $HOME/.config/kitty $directory/config"
		["$HOME/.config/neovim"]="rsync -a --delete $HOME/.config/nvim $directory/config"
		["$HOME/.config/oh-my-posh"]="rsync -a --delete $HOME/.config/oh-my-posh $directory/config"
		["$HOME/.config/picom"]="rsync -a --delete $HOME/.config/picom $directory/config"
		["$HOME/.config/polybar"]="rsync -a --delete $HOME/.config/polybar $directory/config"
		["$HOME/.config/rofi"]="rsync -a --delete $HOME/.config/rofi $directory/config"
		["$HOME/.config/sxhkd"]="rsync -a --delete $HOME/.config/sxhkd $directory/config"
		["$HOME/.config/tmux"]="rsync -a --delete $EXCLUDE $HOME/.config/tmux $directory/config"
		["$HOME/.config/vencord"]="rsync -a --delete $HOME/.config/Vencord/ $directory/config/vencord"
		["$HOME/.config/zsh"]="rsync -a --delete $EXCLUDE $HOME/.config/zsh $directory/config && rsync -a $HOME/.zprofile $directory/config/zsh/.zprofile"
		["$HOME/.config/zathura"]="rsync -a --delete $HOME/.config/zathura $directory/config"
		["$HOME/.config/libinput-gestures.conf"]="rsync -a $HOME/.config/libinput-gestures.conf $directory/config/touchpad/"
		["$HOME/.bash_profile"]="rsync -a $HOME/.bash_profile $directory/config/bash/.bash_profile"
		["$HOME/.bashrc"]="rsync -a $HOME/.bashrc $directory/config/bash/.bashrc"
		["$HOME/.gitconfig"]="rsync -a $HOME/.gitconfig $directory/config/gitconfig"
		["$HOME/.local/bin"]="rsync -a --delete $HOME/.local/bin $directory/local/"
		["$HOME/.local/share/applications"]="rsync -a --delete $HOME/.local/share/applications $directory/local/share/"
		["$HOME/.local/share/crater"]="rsync -a --delete $HOME/.local/share/crater $directory/local/share/"
		["$OBSIDIAN_DIR/.obsidian"]="rsync -a --delete $OBSIDIAN_DIR/.obsidian/* $directory/config/obsidian"
		["/etc/X11/xorg.conf.d/40-libinput.conf"]="rsync -a /etc/X11/xorg.conf.d/40-libinput.conf $directory/config/touchpad/"
		["/etc/tlp.d"]="rsync -a /etc/tlp.d/ $directory/config/tlp"
		["/var/spool/cron/druxorey"]="rsync -a /var/spool/cron/druxorey $directory/config/crontab"
	)

	index=1
	for name in "${!commandList[@]}"; do
		command="${commandList[$name]}"
		if ! eval "$command"; then
			printf "\n$ERROR ⚠ [ERROR]: Unexpected interruption during (%s) backup.$END\n\n" "$name"
			exit 1
		fi
		printf "\r${SUCCESS} ✔ [$END%02d${SUCCESS}] Successfully backed up:$END %s" "$index" "$name"
		tput el
		index=$((index + 1))
	done

	if [ -f "$directory/config/gitconfig" ]; then
		sed -i '1,5c\# user data' "$directory/config/gitconfig"
	fi

	printf "\r${SUCCESS} ✔ All %02d files have been successfully backed up$END" "$index"
	tput el
	printf "\n"

	backupBookmarks >/dev/null 2>&1
}

main "$@"
