#!/bin/bash

BOLD="\033[1m"
RESET="\033[0m"
BLUE="\033[34m"
GREEN="\033[32m"

function help() {
	echo
	echo "USAGE: witch [CATEGORY]"
	echo
	echo "DESCRIPTION: Shows available tools in a specific category."
	echo
	echo "ARGUMENTS:"
	echo "  CATEGORY: multimedia, system, utilities, games, visual."
	echo
	echo "EXAMPLES:"
	echo "  witch multimedia"
	echo "  witch system"
	echo
	echo "Report bugs to https://github.com/druxorey/dotfiles/issues"
	echo
	exit 1
}


function showMultimediaTools() {
	echo
	echo -e "${BOLD}${BLUE}Multimedia Tools:${RESET}"
	echo -e "  - ${GREEN}cmus${RESET} - A small, fast and powerful console music player."
	echo -e "  - ${GREEN}cava${RESET} - Console-based Audio Visualizer for Alsa."
	echo -e "  - ${GREEN}viu${RESET} - A small command-line application to view images."
	echo -e "  - ${GREEN}ani-cli${RESET} - A cli to browse and watch anime."
	echo -e "  - ${GREEN}manga-cli-git${RESET} - A cli to browse and read manga."
	echo
}


function showSystemTools() {
	echo
	echo -e "${BOLD}${BLUE}System Tools:${RESET}"
	echo -e "  - ${GREEN}btop${RESET} - A resource monitor that shows usage and stats."
	echo -e "  - ${GREEN}fastfetch${RESET} - A neofetch-like tool for fetching system information."
	echo -e "  - ${GREEN}ncdu${RESET} - A disk usage analyzer with an ncurses interface."
	echo -e "  - ${GREEN}scrot${RESET} - A command-line screenshot utility."
	echo -e "  - ${GREEN}tokei${RESET} - A program that displays statistics about your code."
	echo
}


function showUtilitiesTools() {
	echo
	echo -e "${BOLD}${BLUE}Utilities Tools:${RESET}"
	echo -e "  - ${GREEN}googler${RESET} - A command-line tool to search Google."
	echo -e "  - ${GREEN}gtypist${RESET} - A typing tutor for the terminal."
	echo -e "  - ${GREEN}lutgen${RESET} - A LUT generator and applicator for color palettes."
	echo
}


function showGamesTools() {
	echo
	echo -e "${BOLD}${BLUE}Games Tools:${RESET}"
	echo -e "  - ${GREEN}tetris-terminal-git${RESET} - A terminal-based Tetris game."
	echo
}


function showVisualTools() {
	echo
	echo -e "${BOLD}${BLUE}Visual Tools:${RESET}"
	echo -e "  - ${GREEN}cmatrix${RESET} - A simple command-line matrix effect."
	echo -e "  - ${GREEN}pipes.sh${RESET} - A terminal screensaver that draws pipes."
	echo -e "  - ${GREEN}peaclock${RESET} - A beautiful and customizable clock for the terminal."
	echo -e "  - ${GREEN}no-more-secrets${RESET} - A tool to recreate the famous 'decrypting text' effect."
	echo -e "  - ${GREEN}genact${RESET} - A nonsense activity generator."
	echo
}


function main() {
	case $1 in
		multimedia)
			showMultimediaTools
			;;
		system)
			showSystemTools
			;;
		utilities)
			showUtilitiesTools
			;;
		games)
			showGamesTools
			;;
		visual)
			showVisualTools
			;;
		*)
			help
			;;
	esac
}

main $@
