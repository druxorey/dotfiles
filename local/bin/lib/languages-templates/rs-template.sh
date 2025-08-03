#!/bin/bash

basicTemplate=$(cat << EOF
fn main() {
	println!("Hello World");
}
EOF
)

codeTemplate=$(cat << EOF
fn main() {
	println!("\n\u{001b}[35m[========= EXERCISE =========]\u{001b}[0m\n");
}
EOF
)
