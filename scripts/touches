#!/bin/bash

FILES="\e[0;32m"
END="\e[0m"

function help() {
    echo
    echo "USAGE: touches [FILES NAME] [FILES QUANTITY] [FILES ROUTE]"
    echo
    echo "DESCRIPTION: Creates a default file in a specific programming language."
    echo
    echo "ARGUMENTS:"
    echo "  FILE TYPE: bash, c++, python, rust."
    echo "  FILE NAME: (Optional) The name of the file."
    echo
    echo "EXAMPLES:"
    echo "  defaultfi c++ helloWorld"
    echo "  defaultfi python"
    echo
    echo "Report bugs to https://github.com/druxorey/pybash-scripts/issues"
    echo
    exit 1
}

function main () {

    [ $# -lt 2 ] && help
    [ $2 -lt 1 ] && error "Error: el numero de ficheros no puede ser menor que 1"

    route=${3:-$(pwd)}

    name=$(echo $1 | rev | cut -d'.' -f2- | rev)
    extension=$(echo $1 | rev | cut -d'.' -f1 | rev)

    for (( i = 1; i <= $2; i++ )); do
        if [ $i -gt 9 ]; then
            file="$name-$i.$extension"
        else
            file="$name-0$i.$extension"
        fi
        touch "$route/$file"
        echo -e "Fichero $FILES$file$END creado" | tr -s /
    done
}

main $@
