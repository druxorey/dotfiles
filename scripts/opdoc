#!/bin/bash

ERROR="\e[1;31m"
END="\e[0m"

documentLocation=~/Documents/Obsidian/Workspace/Cheatsheets/

function errorMessage() {
	echo -e "$ERROR ► the file you are trying to access does not exist$END"
	exit 0
}


function todo() {
	todoLocation="$documentLocation/todo.md"

	if [ -f "$todoLocation" ]; then
		nvim $todoLocation
	else
		echo "Todo file does not exist. Making it..."
		touch $todoLocation
		nvim $todoLocation
	fi
}


function main() {
	if [ -z "$1" ]; then
		errorMessage
		exit 1
	fi

	file=$1

	if [ "$file" == "todo.md" ] || [ "$file" == "todo" ]; then
		todo
		exit 0
	fi

	if [ -f "$documentLocation$file" ]; then
		nvim "$documentLocation$file"
		exit 0
	fi

	errorMessage
}

main $@
