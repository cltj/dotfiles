. /usr/share/bash-completion/completions/git

. ~/.dotfiles/.commonrc

export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="/home/tj/.local/bin/poetry:$PATH"
export PATH="/home/tj/.cache/pypoetry/virtualenvs/fka-databricks-GAMMsPWM-py3.10/bin/python:$PATH"
export PYTHONPATH="/home/tj/.cache/pypoetry/virtualenvs/fka-databricks-GAMMsPWM-py3.10/lib/python3.10/site-packages:$PYTHONPATH"
export GPG_TTY=$(tty)
export HISTSIZE=1000
export HISTFILESIZE=2000
export HOME=$HOME
export XDG_HOME_CONFIG="~/.config"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

eval "$(starship init bash)"
#eval "$(mcfly init bash)"
#eval "$(zoxide init bash)"
