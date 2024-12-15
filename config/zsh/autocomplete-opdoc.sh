#!/bin/zsh

autoload -Uz compinit
compinit
autocomplete_opdoc() {
    local -a files
    files=(${(M)${(f)"$(ls ~/Documents/Obsidian/Workspace/Cheatsheets/)"}:#${1}*})
    _describe 'files' files
}

compdef autocomplete_opdoc opdoc
