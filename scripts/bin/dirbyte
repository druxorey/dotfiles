#!/bin/bash

recursive=0

complete_route=$0
route=$(basename "$complete_route")


# Help message
help() {
    echo "USAGE: $route [-r] [ROUTE]"
    echo
    echo "DESCRIPTION: Calculates the number of bytes occupied by files in the specified directory."
    echo
    echo "ARGUMENTS:"
    echo "  route  Directory path to analyze."
    echo
    echo "OPTIONS:"
    echo "  -h      Shows this help."
    echo "  -r      Analyze directories recursively."
    echo
    exit 1
}

# Check options
while getopts ":rh" opt; do
  case ${opt} in
    r )
      recursive=1
      ;;
    h )
      help
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Check if the number of arguments is correct
if [ $# -ne 1 ]; then
    help
fi

# Check if the directory exist
if [ ! -d $1 ]; then
    echo "Error: directory does not exist"
    exit 1
fi

# Program code
total=0
function analyze_directory() {
    for f in `ls $1`; do
        name="$1/$f"
        if [ -f $name ]; then
            bytes=`ls -l $name | cut -d " " -f 5`
            echo "File $name takes up $bytes bytes" | tr -s /
            (( total = $total + $bytes ))
        elif [ -d $name ] && [ $recursive -eq 1 ]; then
            analyze_directory $name
        fi
    done
}

analyze_directory $1

echo -e "Total: $total bytes"
