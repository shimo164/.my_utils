# ----- Common alias for all profjects. -----
alias python='python3'
alias pip='pip3'

# ignore $ at the beggining of the command
alias \$=''

alias a='cd ..'
alias aa='cd ../..'
alias aaa='cd ../../..'
alias cdd='cd "$(git rev-parse --show-toplevel)"'  # cd to git root directory
alias d='docker'
alias l='ls -ltrh'
alias la='ls -ltrha'
alias ls='ls --color=auto'
alias lld='du -hs $(ls -AF) | sort --human-numeric-sort'  # sort by numrica value
alias llt='du -hs --time $(ls -AF) | sort -k 2,2'  # sort by time
alias g='git'
alias gc='gcloud'
alias ga='git add --all'
alias gaa='git add $(git rev-parse --show-toplevel)'  # git add all files in the git root directory
alias gb='git branch'
alias gco='git commit -m ""'
alias gca='git commit --amend'
alias gl='git log -n 1'
alias glo='git log --oneline -n 5'
alias gp='git pull'
alias gs='git status'
alias gsl='git stash list'

alias grep=grep

# Use trash-cli instead of rm
alias rm='echo "This is not the command you are looking for. Use 'trash'."; false'
# Adding a trailing space in the alias VALUE allows the next word to be checked for alias substitution during expansion.
alias sudo='sudo '

alias tf='terraform'

alias cc='cd_history'  # cd to history path. Used with cd_history.zsh.
alias ff='bash $SCRIPTS/fzf_alias_commands.sh'
alias gg='bash $SCRIPTS/git_branch_checkout.sh'
alias zrc='bash $SCRIPTS/open_zsh_files.sh'
alias zrs='source ~/.zshrc'

# BEGIN: expand alias with space key
function expand-alias() {
	zle _expand_alias
	zle self-insert
}
zle -N expand-alias
bindkey -M main ' ' expand-alias
# END: expand alias with space key

## Use if needed
# alias locate='mdfind -name'  # locate in MacOS
# alias dcd='docker-compose down'
# alias dcu='docker-compose up'
# alias isort2='isort --multi-line 2 --line-length 110 --combine-as '
# alias pt='pytest -p no:warnings -s --tb=short --no-header'
# alias rmnode='rm -rf node_modules/'
