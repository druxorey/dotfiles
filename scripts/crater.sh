#!/bin/bash


function help() {
	echo
	echo "USAGE: crater [FILE TYPE] [FILE NAME]"
	echo
	echo "DESCRIPTION: Creates a default file in a specific programming language."
	echo
	echo "ARGUMENTS:"
	echo "  FILE TYPE: bash, c++, c, python, rust, latex."
	echo "  FILE NAME: (Optional) The name of the file."
	echo
	echo "EXAMPLES:"
	echo "  crater c++ helloWorld"
	echo "  crater python"
	echo
	echo "Report bugs to https://github.com/druxorey/dotfiles/issues"
	echo
	exit 1
}


function main() {
	fileType=$1
	fileName=${2:-"default"}

	case $fileType in
		"bash") extension="sh";;
		"c++") extension="cpp";;
		"c") extension="c";;
		"python") extension="py";;
		"rust") extension="rs";;
		"latex") extension="tex";;
		*) help
		;;
	esac

	. $(dirname $0)/lib/languages-templates/${extension}-template.sh

	eval "content=\$${extension}BasicTemplate"
	echo "$content" > ${fileName}.${extension}
}

main $@
