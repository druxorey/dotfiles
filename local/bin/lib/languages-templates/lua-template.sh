#!/bin/bash

basicTemplate=$(cat << EOF
function main()
    print("Hello World")
end

main()
EOF
)

codeTemplate=$(cat << EOF
function main()
	print("\n\27[35m[========= EXERCISE =========]\27[0m\n")
end

main()
EOF
)
