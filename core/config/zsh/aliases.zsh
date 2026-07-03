
#! ========================================================================== !#
#!
#!                          ███████╗███████╗██╗  ██╗
#!                          ╚══███╔╝██╔════╝██║  ██║
#!                            ███╔╝ ███████╗███████║
#!                           ███╔╝  ╚════██║██╔══██║
#!                          ███████╗███████║██║  ██║
#!                          ╚══════╝╚══════╝╚═╝  ╚═╝
#!
#!                                  ALIASES
#!                         https://github.com/druxorey
#!
#! ========================================================================== !#

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

# remaping
alias vim='nvim'
alias cp='cp -i'
alias cpv='rsync -avh --info=progress2'
alias cat='bat -p'
alias man='batman'
alias fzf='fzf --preview "bat --color=always {}"'
alias convert='magick'
alias grep='grep --color=auto'
alias matrix='cmatrix -C blue'
alias peaclock='peaclock --config ~/.config/peaclock'
alias btop='btop --force-utf'
alias buho='smbclient //192.168.1.10/files'
alias th='trash -v'
alias mods='mods -t "Gemini Consult"'

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

# multimedia
alias yt-1080='yt-dlp -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]"'
alias yt-720='yt-dlp -f "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]"'
alias yt-480='yt-dlp -f "bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]"'
alias yt-mp3='yt-dlp -x --audio-format mp3'
alias youtube='mpv --ytdl-format="bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]"'

# python
alias py='python3'
alias py-activate='source .venv/bin/activate'
alias py-requirements='pip freeze > requirements.txt'
alias py-create='virtualenv .venv'
alias py-desactivate='deactivate'
alias rm-pychache='sudo rm -r __pycache__'

# system
alias logout='bspc quit'
alias shutdown='shutdown now'
alias reload='clear && source $HOME/.config/zsh/.zshrc'
alias clip='xclip -selection clipboard'
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias setkeys='setxkbmap us -variant intl'
alias weather='curl wttr.in'
