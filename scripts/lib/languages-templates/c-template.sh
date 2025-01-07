#!/bin/bash

cBasicTemplate=$(cat << EOF
#include <stdio.h>

int main(int argc, char *argv[]) {
	printf("Hello World\n");
	return 0;
}
EOF
)
