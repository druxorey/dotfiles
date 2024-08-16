#!/bin/bash

documentLocation=~/Documents/Obsidian/Workspace/Cheatsheets/

function errorMessage() {
    echo -e "\e[0;31m ► the file you are trying to access does not exist.\e[0m"
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
    file=$1

    if [ "$file" == "todo" ]; then
        todo
        exit 0
    else
        nvim $documentLocation$file.md
        exit 0
    fi
    errorMessage
}

main $@
