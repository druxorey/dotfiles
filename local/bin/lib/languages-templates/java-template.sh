#!/bin/bash

basicTemplate=$(cat << EOF
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
EOF
)

codeTemplate=$(cat << EOF
public class Main {
    public static void main(String[] args) {
        System.out.println("\\n\\033[0;35m[========= EXERCISE =========]\\033[0m\\n");
    }
}
EOF
)
