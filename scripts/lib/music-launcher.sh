#!/bin/bash

function main() {
	tmux new-session -d -s music \; \
		source-file ~/.config/tmux/custom/cmus.conf \; \
		split-window -h \; \
		send-keys 'cava' C-m \; \
		select-pane -R \; \
		send-keys 'cmus' C-m \; \
		resize-pane -R 20 \; \
		attach
}

main $@
