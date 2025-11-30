export history_keep_num=1000

# Wrapper function for the 'cd' command
function cd() {
    if builtin cd "$@"; then
        cd_history_add_log
    fi
}

# cross-platform mktemp
function _mktemp_compat() {
    if mktemp 2>&1 | grep -q 'illegal option'; then
        mktemp -t cdhist.XXXXXX
    else
        mktemp
    fi
}

# cross-platform tac
function _tac_compat() {
    if command -v tac >/dev/null 2>&1; then
        tac "$@"
    else
        tail -r "$@"
    fi
}

function cd_history_add_log() {
    local temp_file=$(_mktemp_compat)

    if [ -f ~/.cd_history.log ]; then
        while IFS= read -r line; do
            if [[ "$line" != "$PWD" ]]; then
                echo "$line" >> "$temp_file"
            fi
        done < ~/.cd_history.log
    fi

    cat "$temp_file" <(echo "$PWD") > ~/.cd_history.log
    tail -n "$history_keep_num" ~/.cd_history.log > "$temp_file" && mv "$temp_file" ~/.cd_history.log
}

function cd_history() {
    if [ $# -eq 0 ]; then
        if ! command -v fzf >/dev/null 2>&1; then
            echo "cd_history: fzf is not installed" >&2
            return 1
        fi
        local dir
        dir=$(_tac_compat ~/.cd_history.log 2>/dev/null | fzf)
        if [ -n "$dir" ]; then
            builtin cd "$dir" || return
        fi
    elif [ $# -eq 1 ]; then
        builtin cd "$1" || return
    else
        echo "cd_history: too many arguments" >&2
        return 2
    fi
}

_cd_history() {
    _files -/
}

# run compinit only if zsh
if [ -n "$ZSH_VERSION" ]; then
    if ! typeset -f compinit >/dev/null; then
        autoload -Uz compinit
        compinit
    fi
    compdef _cd_history cd_history
fi

[ -e ~/.cd_history.log ] || touch ~/.cd_history.log
