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


function analyze_directory() {
    for f in "$1"/*; do
        fileName="$f"
        if [ -f "$fileName" ]; then
            fileSize=$(ls -l "$fileName" | awk '{print $5}')
            echo -e "File$ROUTE $fileName$END takes up$SIZE $fileSize$END bytes" | tr -s /
            (( sizeInBytes += fileSize ))
            (( totalFiles += 1 ))
        elif [ -d "$fileName" ] && [ $isRecursive -eq 1 ]; then
            analyze_directory "$fileName"
        fi
    done
}


function main() {
    isRecursive=0
    sizeInBytes=0
    totalFiles=0
    memoryUnit=none

    while getopts ":rhkmg" opt; do
        case ${opt} in
            r )
                isRecursive=1
                ;;
            h )
                help
                ;;
            k )
                memoryUnit="kb"
                ;;
            m )
                memoryUnit="mb"
                ;;
            g )
                memoryUnit="gb"
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

    analyze_directory $1

    if [ $memoryUnit = "kb" ]; then
        finalMemoryUnit="kilobytes"
        sizeInKilobytes=$(($sizeInBytes / 1000))
        finalSize=$sizeInKilobytes
    elif [ $memoryUnit = "mb" ]; then
        finalMemoryUnit="megabytes"
        sizeInMegabytes=$(($sizeInBytes / 1000000))
        finalSize=$sizeInMegabytes
    elif [ $memoryUnit = "gb" ]; then
        finalMemoryUnit="gigabytes"
        sizeInGigabytes=$(($sizeInBytes / 1000000000))
        finalSize=$sizeInGigabytes
    else
        finalMemoryUnit="bytes"
        finalSize=$sizeInBytes
    fi

    echo 
    echo -e " ► $FILES$totalFiles files$END occupy a total of $SIZE$finalSize $finalMemoryUnit$END"
    echo 
}

main $@
