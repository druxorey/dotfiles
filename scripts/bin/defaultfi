#!/bin/bash

help() {
    echo
    echo "USAGE: defaultfi [FILE TYPE] [FILE NAME]"
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

fileType=$1
fileName=${2:-"default"}

bashExample=$(cat << EOF
#!/bin/bash

function main(){
    echo "Hello World"
}

main $1
EOF
)

cppExample=$(cat << EOF
#include <iostream>

using namespace std;

int main(){
    cout << "Hello World" << endl;
    return 0;
}
EOF
)

pythonExample=$(cat << EOF
def main():
    print("Hello World")

if __name__ == "__main__":
    main()
EOF
)

rustExample=$(cat << EOF
fn main() {
    println!("Hello World");
}
EOF
)

case $fileType in
    "bash")
        echo "$bashExample" > $fileName.sh
    ;;
    "c++")
        echo "$cppExample" > $fileName.cpp
    ;;
    "python")
        echo "$pythonExample" > $fileName.py
    ;;
    "rust")
        echo "$rustExample" > $fileName.rs
    ;;
    *)
        help
        exit 1
    ;;
esac
