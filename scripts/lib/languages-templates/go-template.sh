#!/bin/bash

goBasicTemplate=$(cat << EOF
package main

import "fmt"

func main() {
	fmt.Println("Hello World")
}
EOF
)
