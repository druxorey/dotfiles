#!/bin/bash

basicTemplate=$(cat << EOF
#include <iostream>

int main(int argc, char *argv[]) {
	std::cout << "Hello World" << '\n';
	return 0;
}
EOF
)

codeTemplate=$(cat << EOF
#include <iostream>

int main(int argc, char *argv[]) {
	std::cout << "\n\e[0;35m[========= EXERCISE =========]\e[0m\n\n";
	return 0;
}
EOF
)
