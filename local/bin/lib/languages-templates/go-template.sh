#!/bin/bash

basicTemplate=$(cat << EOF
package main

import "fmt"

func main() {
	fmt.Println("Hello World")
}
EOF
)

codeTemplate=$(cat << EOF
package main

import "fmt"

func main() {
	fmt.Println("\n\033[0;35m[========= EXERCISE =========]\033[0m\n")
}
EOF
)
