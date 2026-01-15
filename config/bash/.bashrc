#!/bin/bash

#! ========================================================================== !#
#!
#!                       ██████╗  █████╗ ███████╗██╗  ██╗
#!                       ██╔══██╗██╔══██╗██╔════╝██║  ██║
#!                       ██████╔╝███████║███████╗███████║
#!                       ██╔══██╗██╔══██║╚════██║██╔══██║
#!                       ██████╔╝██║  ██║███████║██║  ██║
#!                       ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#!
#!                                   BASHRC
#!
#!                            - Made by Druxorey -
#!                         https://github.com/druxorey
#!
#! ========================================================================== !#

#* ================================= startup ================================ *#

[[ $- != *i* ]] && return

function getStartTime() {
    date +%s.%N > "/dev/shm/${USER}.bashtime.${1}"
}

function getStopTime() {
    local endtime starttime elapsed
    endtime=$(date +%s.%N)
    starttime=$(cat "/dev/shm/${USER}.bashtime.${1}")
    elapsed=$(echo "scale=3; ($endtime - $starttime) / 1" | bc)
    printf "%.3f\n" "$elapsed"
}

ROOTPID=$BASHPID
getStartTime $ROOTPID

FORMAT_DIR='\[\e[1;34m\]'
FORMAT_TIME='\[\e[1;36m\]'
FORMAT_RESET='\[\e[0m\]'

PS0='$(getStartTime $ROOTPID)'
PS1=" ${FORMAT_TIME}[\$(getStopTime \$ROOTPID)ms] ${FORMAT_DIR}\w${FORMAT_RESET} > "
eval "$(zoxide init bash)"

#* ================================= aliases ================================ *#

# directory navigation
alias ls='eza --icons --group-directories-first'
alias la='eza --icons -a --group-directories-first'
alias lt='eza --icons --tree --group-directories-first'
alias ll='eza --icons -lh --group-directories-first'
alias lla='eza --icons -alh --group-directories-first'
alias labc='eza --icons -la'
alias l.='eza -a | grep -E "^\."'
alias cd='z'
alias cdi='zi'
alias ..='z ..'
alias ...='z ../..'
alias cpv='rsync -avh --info=progress2'

# remaping
alias vim='nvim'
alias cp='cp -i'
alias cat='bat -p'
alias man='batman'
alias fzf='fzf --preview "bat --color=always {}"'
alias convert='magick'
alias grep='grep --color=auto'
alias matrix='cmatrix -C blue'
alias peaclock='peaclock --config ~/.config/peaclock'
alias btop='btop --force-utf'
alias oh-my-time='eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/dracula-time.omp.json)"'

# development
alias gadd='git add'
alias gamend='git commit --amend'
alias gbranch='git branch -vv'
alias gcheckout='git checkout'
alias gclone='git clone'
alias gcommit='git commit -v'
alias gdiff='git diff'
alias gfetch='git fetch'
alias glog='git log --all --graph -n 10 --pretty=format:"%C(magenta)%h %C(white) %an %ar %C(auto)   %D%n%s%n"'
alias gmerge='git merge --no-ff'
alias gpop='git stash pop'
alias gpull='git pull'
alias gpush='git push'
alias greset='git reset'
alias grestore='git restore'
alias gstatus='git status -sb'
alias gstash='git stash'
alias gswitch='git switch'
alias gvim='nvim -c "vertical Git" -c "wincmd h | q" '
alias copilot='nvim -c "CopilotChat" -c "wincmd h | q" '

# multimedia
alias yt-1080='yt-dlp -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]"'
alias yt-720='yt-dlp -f "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]"'
alias yt-480='yt-dlp -f "bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]"'
alias yt-mp3='yt-dlp -x --audio-format mp3'
alias youtube='mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best[height<=1080]"'

# python
alias py='python3'
alias rm-pychache='sudo rm -r __pycache__'
alias venv-activate='source .venv/bin/activate'
alias venv-requirements='pip freeze > requirements.txt'
alias venv-create='virtualenv .venv'
alias venv-desactivate='deactivate'

# system
alias logout='bspc quit'
alias shutdown='shutdown now'
alias reload='clear && source ~/.zprofile && source ~/.config/zsh/.zshrc'
alias clip='xclip -selection clipboard'
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias setkeys='setxkbmap us -variant intl'
alias weather='curl wttr.in'
