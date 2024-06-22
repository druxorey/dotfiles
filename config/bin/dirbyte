#!/bin/bash

FILES="\e[0;35m"
ROUTE="\e[0;36m"
SIZE="\e[0;32m"
END="\e[0m"

function help() {
    echo
    echo "USAGE: dirbyte [-r] [ROUTE]"
    echo
    echo "DESCRIPTION: Calculates the number of bytes occupied by files in the specified directory."
    echo
    echo "ARGUMENTS:"
    echo "  route  Directory path to analyze."
    echo
    echo "OPTIONS:"
    echo "  -h      Shows this help."
    echo "  -r      Analyze directories recursively."
    echo "  -k      Shows the final size value en Kilobytes."
    echo "  -m      Shows the final size value en Megabytes."
    echo "  -g      Shows the final size value en Gigabytes."
    echo
    echo "Report bugs to https://github.com/druxorey/pybash-scripts/issues"
    echo
    exit 1
}


function setMemoryUnit() {
    if [ $1 = "kb" ]; then
        memoryUnit="kilobytes"
        decimalFactor=2
        scaleFactor=1000
    elif [ $1 = "mb" ]; then
        memoryUnit="megabytes"
        decimalFactor=4
        scaleFactor=1000000
    elif [ $1 = "gb" ]; then
        memoryUnit="gigabytes"
        decimalFactor=8
        scaleFactor=1000000000
    else
        memoryUnit="bytes"
        decimalFactor=0
        scaleFactor=1
    fi
}


function analyzeDirectory() {
    for f in "$1"/*; do
        fileName="$f"

        if [ -f "$fileName" ]; then
            fileBytesSize=$(ls -l "$fileName" | awk '{print $5}')

            scaledSize=$(printf "%.*f" $decimalFactor $(echo "$fileBytesSize / $scaleFactor" | bc -l))
            sizeInBytes=$(echo "$sizeInBytes + $scaledSize" | bc)

            echo -e "File$ROUTE $fileName$END takes up$SIZE $scaledSize$END $memoryUnit" | tr -s /
            (( totalFiles += 1 ))

        elif [ -d "$fileName" ] && [ $isRecursive -eq 1 ]; then
            analyzeDirectory "$fileName"

        fi
    done
}


function main() {
    isRecursive=0
    sizeInBytes=0
    totalFiles=0
    inputMemoryUnit=none

    while getopts ":rhkmg" opt; do
        case ${opt} in
            r )
                isRecursive=1
                ;;
            h )
                help
                ;;
            k )
                inputMemoryUnit="kb"
                ;;
            m )
                inputMemoryUnit="mb"
                ;;
            g )
                inputMemoryUnit="gb"
                ;;
            \? )
                echo "Invalid Option: -$OPTARG" 1>&2
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    if [ $# -ne 1 ]; then
        help
    elif [ ! -d $1 ]; then
        echo "Error: directory does not exist"
        exit 1
    fi

    setMemoryUnit $inputMemoryUnit
    analyzeDirectory $1
    
    echo 
    echo -e " ► $FILES$totalFiles files$END occupy a total of $SIZE$sizeInBytes$END $memoryUnit"
    echo 
}

main $@
