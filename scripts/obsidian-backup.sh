#!/bin/bash

comandos=(
"cd ~/Documents/Obsidian"
"git add ."
"git commit -m 'Obsidian Backup'"
"git push"
"cd -"
)

successful_execution=true

for comando in "${comandos[@]}"; do
  eval $comando
  if [ $? -ne 0 ]; then
    echo -e """\n \e[1;91m!! Execution Failed !!\n"""
    successful_execution=false
    break
  fi
done

if $successful_execution ; then
  echo -e """\n \e[0;95m► Obsidian files have been successfully backed up \n"""
fi
