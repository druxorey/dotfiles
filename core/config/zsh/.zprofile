
#! ========================================================================== !#
#!
#!                          ███████╗███████╗██╗  ██╗
#!                          ╚══███╔╝██╔════╝██║  ██║
#!                            ███╔╝ ███████╗███████║
#!                           ███╔╝  ╚════██║██╔══██║
#!                          ███████╗███████║██║  ██║
#!                          ╚══════╝╚══════╝╚═╝  ╚═╝
#!
#!                                  ZPROFILE
#!
#!                            - Made by Druxorey -
#!                         https://github.com/druxorey
#!
#! ========================================================================== !#

#* ============================= base directories =========================== *#

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

#* ============================= default programs =========================== *#

export EDITOR="nvim"
export TERM="kitty"
export TERMINAL="kitty"
export MUSPLAYER="cmus"
export BROWSER="brave-origin"
export GIT_EDITOR="nvim"
export PIP_REQUIRE_VIRTUALENV=true
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#* =============================== path export ============================== *#

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export CM_LAUNCHER="rofi"
export CM_HISTLENGTH=10
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true -Dsun.java2d.uiScale=1.25 -Dsun.java2d.dpiaware=true -Dsun.java2d.dpi=96"

export GOPATH="$XDG_CACHE_HOME/go"
export GOBIN="$GOPATH/bin"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

export FZF_DEFAULT_OPTS="
	--color=fg:8,bg:-1,hl:12,fg+:7,bg+:15,hl+:4
	--color=info:5,prompt:4,pointer:4,marker:1,spinner:6,header:1"
export FZF_ALT_C_OPTS='--preview "tree -C {} | head -200"'
export FZF_CTRL_T_OPTS="
	--walker-skip .git,node_modules,target,.local,.steam
	--preview 'bat -n --color=always {}'
	--bind 'ctrl-/:change-preview-window(down|hidden|)'"

export PATH="$HOME/.local/bin:$CARGO_HOME/bin:$GOPATH/bin:$PATH"
