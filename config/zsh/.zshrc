
#! ========================================================================== !#
#!
#!                          ███████╗███████╗██╗  ██╗
#!                          ╚══███╔╝██╔════╝██║  ██║
#!                            ███╔╝ ███████╗███████║
#!                           ███╔╝  ╚════██║██╔══██║
#!                          ███████╗███████║██║  ██║
#!                          ╚══════╝╚══════╝╚═╝  ╚═╝
#!
#!                                   ZSHRC
#
#!                            - Made by Druxorey -
#!                         https://github.com/druxorey
#!
#! ========================================================================== !#

#* ================================= startup ================================ *#

[[ $- != *i* ]] && return
fastfetch --config ~/.config/fastfetch/init.jsonc && echo

eval "$(zoxide init zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.omp.json)" || PS1='[\u@\h \W]\$ '

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
alias play='z Playground'

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
alias buho='smbclient //192.168.1.119/files -U buho'
alias th='trash -v'

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
alias youtube='mpv --ytdl-format="bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]"'

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
alias reload='clear && source ~/.config/zsh/.zshrc'
alias clip='xclip -selection clipboard'
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias setkeys='setxkbmap us -variant intl'
alias weather='curl wttr.in'

#* ================================ zsh setup =============================== *#

# history
HISTFILE="$HOME/.config/history_zsh"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# vim mode
bindkey -v
export KEYTIMEOUT=0

# key bindings
bindkey '^?'    backward-delete-char
bindkey '^u'    backward-kill-line
bindkey '^a'    beginning-of-line
bindkey '^e'    end-of-line
bindkey '^[[3~' delete-char
bindkey '^k'    kill-line
bindkey '^[f'   autosuggest-accept
bindkey '^p'    history-search-backward
bindkey '^n'    history-search-forward

# fzf settings
export FZF_DEFAULT_OPTS="
	--color=fg:8,bg:-1,hl:12,fg+:7,bg+:15,hl+:4
	--color=info:5,prompt:4,pointer:4,marker:1,spinner:6,header:1"
export FZF_ALT_C_OPTS='--preview "tree -C {} | head -200"'
export FZF_CTRL_T_OPTS="
	--walker-skip .git,node_modules,target,.local,.steam
	--preview 'bat -n --color=always {}'
	--bind 'ctrl-/:change-preview-window(down|hidden|)'"
source <(fzf --zsh)

# plugins
autoload -U compinit
[[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]] && compinit || compinit -C

source ~/.config/zsh/fzf-tab/fzf-tab.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh completion settings
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'

#* =============================== zsh widgets ============================== *#

# copping the vi-yank to clipboard
function vi-yank-to-clipboard() {
    zle vi-yank
    echo -n "$CUTBUFFER" | xclip -selection clipboard
}
zle -N vi-yank-to-clipboard
bindkey -M vicmd 'y' vi-yank-to-clipboard
