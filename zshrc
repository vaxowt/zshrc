# Plugins {{{
__MINIPLUG_ZSH="$XDG_DATA_HOME/miniplug/miniplug.zsh"
source "${__MINIPLUG_ZSH}"
# Replace zsh's default completion selection menu with fzf
# Load this plugin first!!!!
miniplug plugin Aloxaf/fzf-tab
# Feature-rich syntax highlighting for ZSH
miniplug plugin zdharma-continuum/fast-syntax-highlighting
# miniplug plugin zsh-users/zsh-syntax-highlighting
miniplug plugin zsh-users/zsh-autosuggestions
miniplug plugin zsh-users/zsh-completions
miniplug load

function miniplug-self-update() {
    echo -n 'Updating miniplug ... '
    curl -sL --create-dirs \
      https://git.sr.ht/~yerinalexey/miniplug/blob/master/miniplug.zsh \
      -o "${__MINIPLUG_ZSH}"
    [[ $? == 0 ]] && echo "done" || echo "failed"
}
# }}}
# Colors {{{
autoload -U colors && colors
eval $(dircolors)
# }}}
# Prompting {{{
autoload -Uz add-zsh-hook

# VSC info {{{
# %s       The current version control system, like git or svn.
# %r       The name of the root directory of the repository
# %S       The current path relative to the repository root directory
# %b       Branch information, like master
# %m       In case of Git, show information about stashes
# %u       Show unstaged changes in the repository
# %c       Show staged changes in the repository
add-zsh-hook precmd vcs_info

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

__VCS_MSG_STATUS="%{$fg_bold[red]%}%m%u%{$reset_color%}%{$fg_bold[green]%}%c%{$reset_color%} "
__VCS_MSG_BASE="%{$fg_bold[cyan]%}%r -> %{$fg_bold[green]%}%b%{$reset_color%}"
zstyle ':vcs_info:*' formats "$__VCS_MSG_STATUS%{$fg[yellow]%}($__VCS_MSG_BASE%{$fg[yellow]%}%)%{$reset_color%}"

# Detect git untracked state
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep -m 1 '^??' &>/dev/null
    then
        hook_com[misc]='?'
    fi
}
# }}}

# Allow funky stuff in prompt
setopt PROMPT_SUBST
__PROMPT_BASE="%{$fg_bold[yellow]%}%n@%m%{$reset_color%}%B:%b%{$fg_bold[cyan]%}%(4~|%-1~/…/%2~|%~)%{$reset_color%} "
__PROMPT_SUFFIX="%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})%(#.#.$)%{$reset_color%} "
__PROMPT_JOBS="%(1j.%{$fg[magenta]%}[%j] %{$reset_color%}.)"
__PROMPT_EXITCODE="%(?..%? )"

function __prompt_python() {
    local python_venv_tool=""
    [[ -n ${PYENV_VERSION} || -f "./.python-version" ]] && python_venv_tool="pyenv"
    [[ -n ${VIRTUAL_ENV} ]] && python_venv_tool="venv"
    [[ ${POETRY_ACTIVE} -eq 1 ]] && python_venv_tool="poetry"
    [[ -z ${python_venv_tool} ]] && return
    local python_version=$(python -c "import platform; print(platform.python_version())")
    print -Pn "%{$bg[blue]%}  %{$bg[green]%} $python_version ($python_venv_tool) %{$reset_color%} "
}

function __prompt_upline_hook() {
    __PROMPT_UPLINE=""
    local newline=$'\n'
    __PROMPT_UPLINE=$(__prompt_python)
    [[ -n ${__PROMPT_UPLINE} ]] && __PROMPT_UPLINE="┏${__PROMPT_UPLINE}${newline}┗"
}

add-zsh-hook precmd __prompt_upline_hook

PROMPT='$__PROMPT_UPLINE$__PROMPT_BASE$__PROMPT_JOBS$__PROMPT_EXITCODE$__PROMPT_SUFFIX'
RPROMPT='${vcs_info_msg_0_}'
# }}}
# History {{{
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=4096
SAVEHIST=4096
# append to history, rather than replace it
setopt APPEND_HISTORY
# Remove old duplicates
setopt HIST_IGNORE_ALL_DUPS
# Ignore commands starting with a space
setopt HIST_IGNORE_SPACE
# Remove superfluous blanks
setopt HIST_REDUCE_BLANKS
# Perform history expansion and reload the line into the editing buffer
setopt HIST_VERIFY
# import commands from history, append typed commands to history
setopt SHARE_HISTORY
# treating `!` specially during command expansion
setopt BANG_HIST
# Do not beep on error in history
unsetopt HIST_BEEP
# }}}
# Changing Directories {{{
# Persistent dirstack {{{
# ref: https://wiki.archlinux.org/title/Zsh#Remembering_recent_directories
# autoload -Uz add-zsh-hook

DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
    dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
    # auto-jump to last directory when startup
    # [[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
__chpwd_dirstack() {
    print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd __chpwd_dirstack

DIRSTACKSIZE=40
# }}}

# make `cd` push the old directory onto the directory stack
setopt AUTO_PUSHD
# do not print the directory stack after pushd or popd
setopt PUSHD_SILENT
# push to HOME if pushd runs without arguments
setopt PUSHD_TO_HOME
# ignore duplicate entries
setopt PUSHD_IGNORE_DUPS
# exchange the meanings of `+` and `-` when used with a number to specify a
# directory in the stack
setopt PUSHD_MINUS
# cd into a path without cd
setopt AUTO_CD
# resolve symlinks
setopt CHASE_LINKS
# }}}
# Expansion and Globbing {{{
# Treat the `#`, `~`, `^` as part of patterns
setopt EXTENDED_GLOB
# Include dotfiles in globbing
setopt GLOB_DOTS
# }}}
# Zle {{{
# Do not beep on error
unsetopt BEEP
# }}}
# Input/Output {{{
# Must use >| to truncate existing files
setopt CLOBBER
# Do not exit on end-of-file
unsetopt IGNORE_EOF
# Ask for confirmation for `rm *' or `rm path/*'
unsetopt RM_STAR_SILENT
# }}}
# Job Control {{{
# No lower prio for background jobs
unsetopt BG_NICE
# Do not Send the HUP signal to running jobs when exits
unsetopt HUP
# }}}
# Bindings {{{
# Default keybinds:
# <C-a> Jump to the beginning of line
# <C-e> Jump to the end of line
# <C-w> Delete a word backward
# <C-u> Delete entire line
# <C-y> Undo delete
# <C-r> Search histories
# <C-d> Delete the letter pointed by cursor
# <C-k> Delete the contents from cursor to the end of line

# <Esc-w> Delete the contents from cursor to the beginning of line
bindkey -e
bindkey '\ew' kill-region

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init() {
        echoti smkx
    }
    function zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# <PageUp> Up a line or history
if [[ -n "${terminfo[kpp]}" ]]; then
    bindkey "${terminfo[kpp]}" up-line-or-history
fi
# <PageDown> Down a line or history
if [[ "${terminfo[knp]}" != "" ]]; then
    bindkey "${terminfo[knp]}" down-line-or-history
fi

# <UpArrow> Up a line or search upward based on starting letters
if [[ -n "${terminfo[kcuu1]}" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
    bindkey '^k' up-line-or-beginning-search
fi
# <DownArrow> Down a line or search downward based on starting letters
if [[ -n "${terminfo[kcud1]}" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
    bindkey '^j' down-line-or-beginning-search
fi

# <Home> Jump to the beginning of line
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
# [End] Jump to the end of line
[[ -n "${terminfo[kend]}" ]] && bindkey "${terminfo[kend]}" end-of-line

# <Option-LeftArrow> Move backward a word
bindkey "^[[1;3D" backward-word
# <Option-RightArrow> Move forward a word
bindkey "^[[1;3C" forward-word
# }}}
# Completion {{{
autoload -U compinit && compinit -d ${XDG_CACHE_HOME}/zsh/zcompdump-$ZSH_VERSION
zmodload -i zsh/complist

# Load bash completions
autoload -U +X bashcompinit && bashcompinit
for f (${XDG_DATA_HOME}/bash-completion/**/*(N.)) source $f
for f (/usr/local/share/bash-completion/**/*(N.)) source $f
for f (/usr/local/etc/bash_completion.d/**/*(N.)) source $f

# Try to correct the spelling of commands
setopt CORRECT
# Cursor move to end after inserting a completion
setopt ALWAYS_TO_END
# Stay there and completion is done from both ends
setopt COMPLETE_IN_WORD
# Do not deep on ambiguous completion
unsetopt LIST_BEEP
# Treat the alias as a distinct command for completion
setopt COMPLETE_ALIASES

zstyle ':completion::complete:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/"
zstyle ':completion:*' menu select=2
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*' accept-exact '*(N)'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:commands' list-colors '=*=31'
zstyle ':completion:*:options' list-colors '=^(-- *)=33'

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
# }}}
# Aliases {{{
# Safe remove
# alias rm="rm -i"
alias rm='echo "use \`trash\` for safety"; false'

# A trailing space in VALUE causes the next word to be checked for alias
# substitution when the alias is expanded.
alias sudo='sudo '

alias copy='rsync -Pha'

alias ..="cd .."
alias ...="cd ../.."
alias cdl="cd -1"
alias cdd='__v=$(dirs -p | fzf) && cd "${__v/#\~/$HOME}" && unset __v'


alias ls="ls --color=auto"
alias l="ls -alh"
alias ll="ls -lh"

alias grep="grep --color=auto"

alias sc='systemctl'
alias scu='systemctl --user'
compdef sc=systemctl
compdef scu=systemctl

alias gst="git status"
alias gau='git add --update'
alias gcm="git commit -m"
alias glg="git log --oneline --graph --all"
alias gpl="git pull"
alias gco="git checkout"

alias gd='goldendict'
# }}}
# Plugins (after) {{{
# Aloxaf/fzf-tab {{{2
enable-fzf-tab
# }}}
# }}}
# Misc {{{
# Query IP address {{{
function whatip() {
    local ip138='http://api.ip138.com/query/'
    local datatype='txt'
    local token="$(cat ${XDG_CONFIG_HOME}/secrets/ip138.com.token)"
    local target_ip

    echo "Data from ${ip138}"

    if [[ $# -eq 0 ]]; then
        curl "${ip138}?&datatype=${datatype}&token=${token}"
    else
        for target in $*; do
            curl "${ip138}?&datatype=${datatype}&token=${token}&ip=${target}"
            echo
        done
    fi
    echo
}
# }}}
# Pastebin service {{{
function pastebin() {
    local service_url='https://x0.at'
    case "$1" in
        -h|--help)
            echo 'Usage: pastebin [FILE]'
            echo 'Upload FILE/STDIN to pastebin service.'
            echo '\n -h, --help    Show this help\n'
            echo "Service provider: $service_url"
            return
            ;;
    esac

    if [[ -z "$1" ]]; then
        curl -F "file=@-" "$service_url"
    else
        if [[ -r "$1" ]]; then
            curl -F "file=@$1" "$service_url"
        else
            echo "file does not exist: $1" && return 1
        fi
    fi
}
# }}}
# Automatically change directory after exiting ranger {{{
function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    command rm -f -- "$tempfile"
}

alias ra="ranger-cd"
# }}}
# fzf {{{
source /usr/share/fzf/key-bindings.zsh
# }}}
# pyenv {{{
eval "$(pyenv init -)"
# }}}
# zoxide {{{
eval "$(zoxide init zsh)"
# }}}
# Remove duplicates in variables {{{
typeset -U path fpath
# }}}
# }}}
# vim: fdm=marker
