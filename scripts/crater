#!/bin/bash

bashExample=$(cat << EOF
#!/bin/bash

function main() {
	echo "Hello World"
}

main \$@
EOF
)

cppExample=$(cat << EOF
#include <iostream>

int main() {
	std::cout << "Hello World" << '\n';
	return 0;
}
EOF
)

pythonExample=$(cat << EOF
def main():
	print("Hello World")

if __name__ == "__main__":
	main()
EOF
)

rustExample=$(cat << EOF
fn main() {
	println!("Hello World");
}
EOF
)

latexExample=$(cat << EOF
\documentclass[12pt]{article}

\title{Example Documtent}
\author{Author Name}
\date{\today}

\begin{document}

\maketitle

\section{Title}
text

\subsection{Subtitle}
text

\end{document}
EOF
)


function help() {
	echo
	echo "USAGE: crater [FILE TYPE] [FILE NAME]"
	echo
	echo "DESCRIPTION: Creates a default file in a specific programming language."
	echo
	echo "ARGUMENTS:"
	echo "  FILE TYPE: bash, c++, python, rust, latex."
	echo "  FILE NAME: (Optional) The name of the file."
	echo
	echo "EXAMPLES:"
	echo "  crater c++ helloWorld"
	echo "  crater python"
	echo
	echo "Report bugs to https://github.com/druxorey/pybash-scripts/issues"
	echo
	exit 1
}


function main() {
	fileType=$1
	fileName=${2:-"default"}
	case $fileType in
		"bash") echo "$bashExample" > $fileName.sh;;
		"c++") echo "$cppExample" > $fileName.cpp;;
		"python") echo "$pythonExample" > $fileName.py;;
		"rust") echo "$rustExample" > $fileName.rs;;
		"latex") echo "$latexExample" > $fileName.tex;;
		*) help
		;;
	esac
}

main $@
