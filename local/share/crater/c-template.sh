#!/bin/bash

basicTemplate=$(cat << EOF
#include <stdio.h>

int main(int argc, char *argv[]) {
	printf("Hello World\n");
	return 0;
}
EOF
)

codeTemplate=$(cat << EOF
#include <stdio.h>

int main(int argc, char *argv[]) {
	printf("\n\e[0;35m[========= EXERCISE =========]\e[0m\n\n");
	return 0;
}
EOF
)
