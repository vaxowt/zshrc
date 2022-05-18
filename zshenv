export TERM="xterm-256color"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export FPATH="${XDG_DATA_HOME}/zsh/site-functions:${FPATH}"
export PATH="${HOME}/.cargo/bin:${HOME}/.local/bin:${PATH}"
export EDITOR="vim"

alias vi='vim -u NONE'

# Proxies
export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
export HTTP_PROXY="http://127.0.0.1:9022/"
export HTTPS_PROXY="http://127.0.0.1:9022/"

# pyenv
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
eval "$(pyenv init --path)"

# zoxide
export _ZO_DATA="${XDG_CACHE_HOME}/zoxide/database"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob !^node_modules$ --glob !.git'
# virutalenvs: Disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1
# Read man page with vim
# export MANPAGER="vim -M +MANPAGER -"
# Uncrustify
export UNCRUSTIFY_CONFIG="${XDG_CONFIG_HOME}/uncrustify/uncrustify.cfg"
# nnn
export NNN_TRASH=1
export NNN_FIFO=/tmp/nnn.fifo

# Let vim respect XDG
export VIMINIT='if !has("nvim") | set rtp^=$XDG_CONFIG_HOME/vim | let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | so $MYVIMRC | endif'
