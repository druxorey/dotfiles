#!/bin/bash

documentLocation=~/Workspace/dotfiles/resources/documents/

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
    fileList=("todo" "vim-cheatsheets" "guides-ideas")

    for i in "${fileList[@]}"; do
        if [ "$i" == "$file" ]; then
            if [ "$file" == "todo" ]; then
                todo             
                exit 0
            else
                nvim $documentLocation$file.md
                exit 0
            fi
        fi
    done
    errorMessage
}

main $@
