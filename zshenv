# export TERM="xterm-256color"

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"
export FPATH="${XDG_DATA_HOME}/zsh/site-functions:${FPATH}"
export PATH="${HOME}/.local/bin:${PATH}"

function find-os() {
    # Copyright: https://gist.github.com/k-sriram/6b8810da73e2fd331eaa5a5c2ffb148e
    local UNAME OS
    # Determine OS platform
    UNAME=$(uname | tr "[:upper:]" "[:lower:]")
    # If Linux, try to determine specific distribution
    if [[ "$UNAME" == "linux" ]]; then
        # First check if os-release is available
        if [[ -f /etc/os-release ]]; then
            OS=$(grep -Po "(?<=^ID=).*(?=$)" /etc/os-release)
        # If available, use LSB to identify distribution
        elif [[ -f /etc/lsb-release || -d /etc/lsb-release.d ]]; then
            OS=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
        # Check for Termux (Android)
        elif [[ "${PREFIX-}" == *com.termux* ]]; then
            OS=termux
        else
            OS=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
        fi
    elif [[ -n "${MSYSTEM-}" ]]; then
        OS=msys2
    fi
    # For everything else (or if above failed), just use generic identifier
    [[ "$OS" == "" ]] && OS=$UNAME
    OS=${(L)OS}
    echo -n $OS
}

export __OS=$(find-os)

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
# Disable the default python venv prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
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

# python venv
export PYTHON_VENV_HOME="${XDG_DATA_HOME}/venv"

if [[ -f "${XDG_CONFIG_HOME}/zsh/env" ]]; then
    source "${XDG_CONFIG_HOME}/zsh/env"
fi
