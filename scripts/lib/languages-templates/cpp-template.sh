#!/bin/bash

cppBasicTemplate=$(cat << EOF
#include <iostream>

int main(int argc, char *argv[]) {
	std::cout << "Hello World" << '\n';
	return 0;
}
EOF
)
