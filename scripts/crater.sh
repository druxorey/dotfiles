#!/bin/bash

function help() {
	echo
	echo "USAGE: crater [FILE TYPE] [FILE NAME] [TEMPLATE TYPE]"
	echo
	echo "DESCRIPTION: Creates a default file in a specific programming language."
	echo
	echo "ARGUMENTS:"
	echo "  FILE TYPE: bash, c, c++, go, html, latex, lua, python, rust."
	echo "  FILE NAME: (Optional) The name of the file."
	echo "  TEMPLATE TYPE: (Optional) basic, code."
	echo
	echo "EXAMPLES:"
	echo "  crater html index"
	echo "  crater python"
	echo "  crater c++ wordFinder code"
	echo
	echo "Report bugs to https://github.com/druxorey/dotfiles/issues"
	echo
	exit 1
}


function main() {
	fileType=$1
	fileName=${2:-"default"}
	templateName=${3:-"basic"}

	case $fileType in
		"bash") extension="sh";;
		"c") extension="c";;
		"c++") extension="cpp";;
		"cpp") extension="cpp";;
		"golang") extension="go";;
		"go") extension="go";;
		"html") extension="html";;
		"latex") extension="tex";;
		"lua") extension="lua";;
		"python") extension="py";;
		"rust") extension="rs";;
		*) help
		;;
	esac

	. $(dirname $0)/lib/languages-templates/${extension}-template.sh

	eval "content=\$${templateName}Template"

	if [[ -z "$content" ]]; then
		echo -e "\033[0;31mERROR: Template not found.\033[0m"
		exit 1
	fi

	echo "$content" > ${fileName}.${extension}
}

main $@
