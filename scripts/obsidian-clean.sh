#!/bin/bash

VAULT_PATH="${HOME}/Documents/[01] Obsidian/"

ERROR="\e[1;31mERROR:"
WARN="\e[1;33mWARNING:"
SUCCESS="\e[1;32mSUCCESS:"
END="\e[0m"

function help() {
    echo
    echo "USAGE: compress [-o OUTPUT_FILE] [-l COMPRESSION_LEVEL] INPUT_FILE"
    echo
    echo "DESCRIPTION: Compresses a video file using ffmpeg with a specified compression level."
    echo
    echo "ARGUMENTS:"
    echo "  -o OUTPUT_FILE: (Optional) Specify the name of the output file."
    echo "  -l COMPRESSION_LEVEL: (Optional) Compression level (0-3)."
    echo "      0: Low compression (default)."
    echo "      1: Medium compression."
    echo "      2: High compression."
    echo "      3: Maximum compression."
    echo "  INPUT_FILE: The video file to be compressed."
    echo
    echo "EXAMPLES:"
    echo "  compress -o output.mp4 -l 2 input.mp4"
    echo "  compress input.mp4"
    echo
    echo "Report bugs to https://github.com/druxorey/dotfiles/issues"
    echo
    exit 1
}


function main() {

	if [ ! -d "${VAULT_PATH}/.git" ]; then
		echo "$ERROR Obsidian vault not found."
		return
	fi

	(
		cd "${VAULT_PATH}" || { echo "$ERROR Failed to change directory.$END"; return; }
		git checkout --orphan temp_branch || { echo "$ERROR Failed to create orphan branch.$END"; return; }
		git add -A && git commit -m "Clean branch - $(date +%d-%m-%Y_%H-%M-%S)" || { echo "$ERROR Failed to commit changes.$END"; return; }
		git branch -D main || { echo "$ERROR Failed to delete main branch.$END"; return; }
		git branch -m main || { echo "$ERROR Failed to rename branch to main.$END"; return; }
		git push -f origin main || { echo "$ERROR Failed to push to origin.$END"; return; }
	)
}

main "$@"
