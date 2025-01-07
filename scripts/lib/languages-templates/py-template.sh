#!/bin/bash

pyBasicTemplate=$(cat << EOF
def main():
	print("Hello World")

if __name__ == "__main__":
	main()
EOF
)
