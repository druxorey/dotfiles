
#! ========================================================================== !#
#!
#!                  ███████╗███████╗██╗  ██╗██████╗  ██████╗
#!                  ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#!                    ███╔╝ ███████╗███████║██████╔╝██║
#!                   ███╔╝  ╚════██║██╔══██║██╔══██╗██║
#!                  ███████╗███████║██║  ██║██║  ██║╚██████╗
#!                  ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#!
#!                                   ZSHRC
#
#!                            - Made by Druxorey -
#!                         https://github.com/druxorey
#!
#! ========================================================================== !#

#* ================================= startup ================================ *#

[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '
fastfetch --config ~/.config/fastfetch/init.jsonc && echo

eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/dracula-default.omp.json)"

#* ================================= aliases ================================ *#

# directory navigation
alias vim='nvim'
alias cat='bat -p'
alias man='batman'
alias fzf='fzf --preview "bat --color=always {}"'
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
alias fk='fuck'
alias cp='cp -i'
alias th='trash'
alias thl='trash-list'
alias thr='trash-restore'
alias convert='magick'
alias grep='grep --color=auto'
alias matrix='cmatrix -C blue'
alias peaclock='peaclock --config ~/.config/peaclock'
alias btop='btop --force-utf'
alias oh-my-time='eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/dracula-time.omp.json)"'
alias clip='xclip -selection clipboard'

# pacman and yay
alias unlock='sudo rm /var/lib/pacman/db.lck'

# git
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
alias gpull='git pull'
alias gpush='git push'
alias greset='git reset'
alias grestore='git restore'
alias gstatus='git status -sb'
alias gvim='nvim -c "vertical Git" -c "wincmd h | q" '

# macros
alias copilot='nvim -c "CopilotChat" -c "wincmd h | q" '
alias cpv='rsync -avh --info=progress2'
alias mdtopdf='pandoc $1 -o default.pdf --pdf-engine=xelatex -V mainfont="Arial" monofont="Arial"'
alias trans-es='trans -s english -t spanish'
alias setkeys='setxkbmap us -variant intl'
alias reload='clear && source ~/.zprofile && source ~/.config/zsh/.zshrc'
alias yt-mp3='yt-dlp -x --audio-format mp3'
alias yt-1080='yt-dlp -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]"'
alias yt-720='yt-dlp -f "bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]"'
alias yt-480='yt-dlp -f "bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]"'
alias youtube='mpv --ytdl-format="bestvideo[height<=1080]+bestaudio/best[height<=1080]"'
alias weather='curl wttr.in'

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

#* ================================ zsh setup =============================== *#

# history
HISTFILE="$HOME/.config/zsh/zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt sharehistory
setopt hist_ignore_space

# vim mode
bindkey -v
export KEYTIMEOUT=0

# key bindings
bindkey '^?'      backward-delete-char
bindkey '^u'      backward-kill-line
bindkey '^a'      beginning-of-line
bindkey '^e'      end-of-line
bindkey '^[[3~'   delete-char
bindkey '^k'      kill-line
bindkey '^[f'     autosuggest-accept

# fzf settings
export FZF_ALT_C_OPTS='--preview "tree -C {} | head -200"'
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,.local,.steam
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
source <(fzf --zsh)

# plugins
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
