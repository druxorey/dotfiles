#!/bin/bash

declare WORKSPACE_DIR="$HOME/Workspace"

function getProjects() {
    find "$WORKSPACE_DIR/Projects" "$WORKSPACE_DIR/Forks" "$WORKSPACE_DIR/Websites" -maxdepth 1 -mindepth 1 -type d 2>/dev/null

	find -L "$WORKSPACE_DIR/Academic" \
		-maxdepth 1 -mindepth 1 -type d \( -name "* - Proyectos" -o -name "* - Laboratorios" \) 2>/dev/null |
		while read -r sub_dir; do
			find -L "$sub_dir" -maxdepth 1 -mindepth 1 -type d 2>/dev/null
		done
}

function main() {

	echo -e "\0message\x1fSelect a project session to launch\n"

	if [ -z "$1" ]; then
		getProjects | sed "s|$WORKSPACE_DIR/||" | while read -r project; do
            echo -e "${project}\0icon\x1fcs-workspaces"
        done
		exit 0
	fi

	local selectedProject="$1"
	local projectPath=""

	if [[ "$selectedProject" == *"Academic"* ]]; then
		local expandedPath=$(find "$WORKSPACE_DIR/$selectedProject" -maxdepth 1 -type d -name "*Desarrollo" -print -quit)
		projectPath="${expandedPath:-$WORKSPACE_DIR/$selectedProject}"
	else
		projectPath="$WORKSPACE_DIR/$selectedProject"
	fi

	local sessionName=$(basename "$selectedProject" | tr '.' '_')
	if ! tmux has-session -t "$sessionName" 2>/dev/null; then

		tmux new-session -d -s "$sessionName:1" -c "$projectPath" -n "test"

		tmux new-window -t "$sessionName:2" -c "$projectPath" -n "dev"
		tmux send-keys -t "$sessionName:2" "nvim" C-m

		tmux new-window -t "$sessionName:3" -c "$projectPath" -n "dev"
		tmux send-keys -t "$sessionName:3" "nvim" C-m

		tmux new-window -t "$sessionName:4" -c "$projectPath" -n "files"
		tmux send-keys -t "$sessionName:4" "yazi" C-m

		tmux new-window -t "$sessionName:5" -c "$projectPath" -n "git"
		tmux split-window -h -t "$sessionName:5" -c "$projectPath"
		tmux send-keys -t "$sessionName:5.1" "lazygit" c-m
		tmux send-keys -t "$sessionName:5.2" "nvim -c 'vertical Git' -c 'wincmd h | q' " c-m

		if [[ "$selectedProject" == *"Academic"* ]]; then
			tmux new-window -t "$sessionName:6" -c "$WORKSPACE_DIR/$selectedProject" -n "latex"
			tmux send-keys -t "$sessionName:6" "nvim *.tex" C-m
		fi

		tmux select-window -t "$sessionName:2"
	fi

	nohup kitty --title "Project: $sessionName" -e tmux attach-session -t "$sessionName" >/dev/null 2>&1 &
	exit 0
}

main "$@"
