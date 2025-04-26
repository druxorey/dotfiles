#!/bin/bash

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

	if [ $# -eq 0 ]; then
		echo "Error: No arguments provided."
		return
	fi

	local vaultPath="${HOME}/Documents/Obsidian"
	local vaults=("${(f)$(find "${vaultPath}" -mindepth 1 -maxdepth 1 -type d -not -name '.git' -exec basename {} \;)}")

	for vault in "${vaults[@]}"; do
		if [[ "${1:l}" = "${vault:l}" ]]; then
			(
			cd $vaultPath
			nvim $vault
			)
			return
		fi
	done

	echo "$ERROR Vault not found.$END"
}

main "$@"
