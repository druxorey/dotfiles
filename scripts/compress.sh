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
	local inputFile=""
	local outputFile=""
	local compressionLevel=0

	while getopts "o:l:h" opt; do
		case $opt in
			o) outputFile="$OPTARG" ;;
			l) compressionLevel="$OPTARG" ;;
			h) help ;;
			*) help ;;
		esac
	done

	shift $((OPTIND - 1))

	inputFile="$1"

	if [[ -z "$inputFile" ]]; then
		echo -e "$ERROR Input file is required"
		return 1
	fi

	if [[ -z "$outputFile" ]]; then
		local date=$(date +%d-%m-%Y_%H-%M-%S)
		outputFile="${compressionLevel}_${date}.${inputFile#*.}"
	fi

	case $compressionLevel in
		0) compression=20 ;;
		1) compression=25 ;;
		2) compression=30 ;;
		3) compression=35 ;;
		*) echo -e "$ERROR Wrong compression level" ; return 1 ;;
	esac

	ffmpeg -i "$inputFile" -vcodec libx264 -crf $compression "$outputFile"

	echo -e "\n$SUCCESS File $inputFile compressed to $outputFile with compression level $compressionLevel\n"
}

main "$@"
