#!/bin/bash

WORKSPACE="$HOME/Workspace"

function getProjects() {
    find "$WORKSPACE/Projects" "$WORKSPACE/Forks" "$WORKSPACE/Websites" -maxdepth 1 -mindepth 1 -type d 2>/dev/null

	find -L "$WORKSPACE/Academic" \
		-maxdepth 1 -mindepth 1 -type d \( -name "* - Proyectos" -o -name "* - Laboratorios" \) 2>/dev/null |
		while read -r sub_dir; do
			find -L "$sub_dir" -maxdepth 1 -mindepth 1 -type d 2>/dev/null
		done
}

function main() {
	if [ -z "$1" ]; then
		getProjects | sed "s|$WORKSPACE/||"
	else
		SELECTED="$1"
		SESSION_NAME=$(basename "$SELECTED" | tr '.' '_')
		BASE_PATH="$WORKSPACE/$SELECTED"
		isAcademic=false

		if [[ "$SELECTED" == *"Academic"* ]]; then
			EXPANDED_PATH=$(find "$WORKSPACE/$SELECTED" -maxdepth 1 -type d -name "*Desarrollo" -print -quit)
			PROJECT_PATH="${EXPANDED_PATH:-$WORKSPACE/$SELECTED}"
			isAcademic=true
		else
			PROJECT_PATH="$WORKSPACE/$SELECTED"
		fi

		if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then

			tmux new-session -d -s "$SESSION_NAME:1" -c "$PROJECT_PATH" -n "test"
			tmux split-window -h -t "$SESSION_NAME:1" -c "$PROJECT_PATH"

			tmux new-window -t "$SESSION_NAME:2" -c "$PROJECT_PATH" -n "dev"
			tmux send-keys -t "$SESSION_NAME:2" "nvim" C-m

			tmux new-window -t "$SESSION_NAME:3" -c "$PROJECT_PATH" -n "dev"
			tmux send-keys -t "$SESSION_NAME:3" "nvim" C-m

			tmux new-window -t "$SESSION_NAME:4" -c "$PROJECT_PATH" -n "copilot"
			tmux send-keys -t "$SESSION_NAME:4" "nvim -c 'CopilotChat' -c 'wincmd h | q'" C-m

			tmux new-window -t "$SESSION_NAME:5" -c "$PROJECT_PATH" -n "git"
			tmux split-window -h -t "$SESSION_NAME:5" -c "$PROJECT_PATH"
			tmux send-keys -t "$SESSION_NAME:5.1" "lazygit" c-m
			tmux send-keys -t "$SESSION_NAME:5.2" "nvim -c 'vertical Git' -c 'wincmd h | q' " c-m

			if [[ "$isAcademic" == "true" ]]; then
				tmux new-window -t "$SESSION_NAME:6" -c "$BASE_PATH" -n "latex"
				tmux send-keys -t "$SESSION_NAME:6" "nvim *.tex" C-m
			fi

			tmux select-window -t "$SESSION_NAME:2"
		fi

		nohup kitty --title "Project: $SESSION_NAME" -e tmux attach-session -t "$SESSION_NAME" >/dev/null 2>&1 &
		exit 0
	fi
}

main "$@"
