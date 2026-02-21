#!/bin/bash

VAULT_PATH="${HOME}/Documents/A1 Obsidian/"

FORMAT_ERROR="\e[1;31m[ERROR]"
FORMAT_SUCCESS="\e[1;32m[SUCCESS]"
FORMAT_END="\e[0m"

function main() {
	if [ ! -d "${VAULT_PATH}/.git" ]; then
		printf "$FORMAT_ERROR Obsidian vault not found.$FORMAT_END\n"
		exit 1
	fi

	(
		cd "${VAULT_PATH}" || { printf "$FORMAT_ERROR Failed to change directory.$FORMAT_END"; return; }
		git checkout --orphan temp_branch || { printf "$FORMAT_ERROR Failed to create orphan branch.$FORMAT_END"; return; }
		git add -A && git commit -m "Clean branch - $(date +%d-%m-%Y_%H-%M-%S)" || { printf "$FORMAT_ERROR Failed to commit changes.$FORMAT_END"; return; }
		git branch -D main || { printf "$FORMAT_ERROR Failed to delete main branch.$FORMAT_END"; return; }
		git branch -m main || { printf "$FORMAT_ERROR Failed to rename branch to main.$FORMAT_END"; return; }
		git push -f origin main || { printf "$FORMAT_ERROR Failed to push to origin.$FORMAT_END"; return; }
	)

	printf "$FORMAT_SUCCESS Obsidian vault cleaned.$FORMAT_END\n"
}

main "$@"
