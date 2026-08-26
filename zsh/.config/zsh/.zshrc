HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

setopt NO_AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

setopt NO_BEEP

setopt CORRECT
setopt INTERACTIVE_COMMENTS

setopt NO_CASE_GLOB
setopt EXTENDED_GLOB
setopt NUMERIC_GLOB_SORT

setopt NO_NOTIFY

bindkey -v

autoload -Uz compinit
if [[ -n "$XDG_CACHE_HOME/zsh/.zcompdump"(#qN.mh+24) ]]; then
	compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"
else
	compinit -C -d "$XDG_CACHE_HOME/zsh/.zcompdump"
fi

PS1='%F{blue}%~%f %# '

alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias grep='grep --color=auto'
alias v='nvim'

export GPG_TTY=$(tty)

