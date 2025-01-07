#!/bin/bash

luaBasicTemplate=$(cat << EOF
function main()
    print("Hello World")
end

main()
EOF
)
