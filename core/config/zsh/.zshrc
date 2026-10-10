
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
#!                         https://github.com/druxorey
#!
#! ========================================================================== !#

[[ $- != *i* ]] && return
[[ -f "$ZDOTDIR/secrets.zsh" ]]   && source "$ZDOTDIR/secrets.zsh"
[[ -f "$ZDOTDIR/aliases.zsh" ]]   && source "$ZDOTDIR/aliases.zsh"
[[ -f "$ZDOTDIR/functions.zsh" ]] && source "$ZDOTDIR/functions.zsh"

fastfetch --config ~/.config/fastfetch/init.jsonc && echo
eval "$(zoxide init zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.omp.json)" || PS1='[\u@\h \W]\$ '

#* ================================ zsh setup =============================== *#

# history
HISTFILE="$XDG_CACHE_HOME/zsh/history"
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
setopt LIST_PACKED

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

source <(fzf --zsh)

# plugins
_comp_dumpfile="$XDG_CACHE_HOME/zsh/zcompdump"
autoload -U compinit
[[ -n $_comp_dumpfile(#qN.mh+24) ]] && compinit -d "$_comp_dumpfile" || compinit -C -d "$_comp_dumpfile"
if [[ ! -f "${_comp_dumpfile}.zwc" || "$_comp_dumpfile" -nt "${_comp_dumpfile}.zwc" ]]; then
	zcompile -U "$_comp_dumpfile"
fi

source $HOME/.config/zsh/fzf-tab/fzf-tab.zsh
source $HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh completion settings
_comp_options+=(globdots)

zstyle ':completion:*' matcher-list \
		'm:{a-zA-Z}={A-Za-z}' \
		'+r:|[._-]=* r:|=*' \
		'+l:|=*'

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

zstyle ':fzf-tab:*' fzf-flags --style=full --height=20% --pointer '>' --gutter ' ' \
                    --color 'pointer:green:bold,bg+:-1:,fg+:green:bold,info:blue:bold,marker:yellow:bold,hl:gray:bold,hl+:gray:bold' \
                    --input-label ' Search ' --color 'input-border:blue,input-label:blue:bold' \
                    --list-label ' Results ' --color 'list-border:green,list-label:green:bold' \
                    --preview-label ' Preview ' --preview-label-pos '27:bottom' --color 'preview-border:magenta,preview-label:magenta:bold'

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons=always --color=always -a $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --icons=always --color=always -a $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --icons=always --color=always -a $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --color=always --theme=base16 $realpath'
