#!/bin/bash

basicTemplate=$(cat << EOF
#!/bin/bash

function main() {
	echo "Hello World"
}

main \$@
EOF
)

codeTemplate=$(cat << EOF
#!/bin/bash

function main() {
	echo -e "\n\033[0;35m[========= EXERCISE =========]\033[0m\n"
}

main \$@
EOF
)
