#!/bin/bash

basicTemplate=$(cat << EOF
def main():
    print("Hello World")

if __name__ == "__main__":
    main()
EOF
)

codeTemplate=$(cat << EOF
def main():
    print("\n\033[35m[========= EXERCISE =========]\033[0m\n")

if __name__ == "__main__":
    main()
EOF
)
