
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
export PATH=$PATH:~/.local/bin

#* ============================= default programs =========================== *#

export EDITOR="nvim"
export TERM="kitty"
export TERMINAL="kitty"
export MUSPLAYER="cmus"
export BROWSER="brave"
export GIT_EDITOR="nvim"

#* =============================== path export ============================== *#

export CARGO_HOME='$XDG_DATA_HOME'/cargo
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.xrender=true -Dsun.java2d.uiScale=1.25 -Dsun.java2d.dpiaware=true -Dsun.java2d.dpi=96"
export CM_LAUNCHER="rofi"
export CM_HISTLENGTH=10
