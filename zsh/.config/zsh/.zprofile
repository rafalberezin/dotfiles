export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

export GNUPGHOME="$XDG_DATA_HOME/gnupg"

export HISTFILE="$XDG_STATE_HOME/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

export LESSHISTFILE="$XDG_STATE_HOME/less/history"
mkdir -p "$(dirname "$LESSHISTFILE")"

typeset -U path PATH
path=("$HOME/.local/bin" $path)

