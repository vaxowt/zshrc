export TERM="xterm-256color"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"
export FPATH="${XDG_DATA_HOME}/zsh/site-functions:${FPATH}"
export PATH="${HOME}/.local/bin:${PATH}"

# Let vim respect XDG
if command -v vim &> /dev/null; then
    export GVIMINIT='let $MYGVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/gvimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYGVIMRC'
    export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'
fi

# cargo
if command -v cargo &> /dev/null; then
    export PATH="${HOME}/.cargo/bin:${PATH}"
fi

# zoxide
if command -v zoxide &> /dev/null; then
    export _ZO_DATA="${XDG_CACHE_HOME}/zoxide/database"
fi

# fzf
if command -v fzf &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob !^node_modules$ --glob !.git'
fi
# virutalenvs: Disable the default virtualenv prompt change
if command -v virtualenv &> /dev/null; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
fi
# Read man page with vim
# export MANPAGER="vim -M +MANPAGER -"
# Uncrustify
if command -v uncrustify &> /dev/null; then
    export UNCRUSTIFY_CONFIG="${XDG_CONFIG_HOME}/uncrustify/uncrustify.cfg"
fi
# nnn
if command -v nnn &> /dev/null; then
    export NNN_TRASH=1
    export NNN_FIFO=/tmp/nnn.fifo
fi

if [[ -f "${XDG_CONFIG_HOME}/zsh/env" ]]; then
    source "${XDG_CONFIG_HOME}/zsh/env"
fi
