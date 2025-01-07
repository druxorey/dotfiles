#!/bin/bash

shBasicTemplate=$(cat << EOF
#!/bin/bash

function main() {
	echo "Hello World"
}

main \$@
EOF
)
