if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

if [ -f /etc/bash_completion.d/git ]; then
    . /etc/bash_completion.d/git
fi

. ~/.dotfiles/.commonrc

export PATH="/home/tj/.local/bin/poetry:$PATH"
#export PATH="/home/tj/.cache/pypoetry/virtualenvs/fka-databricks-GAMMsPWM-py3.10/bin/python:$PATH"
#export PYTHONPATH="/home/tj/.cache/pypoetry/virtualenvs/fka-databricks-GAMMsPWM-py3.10/lib/python3.10/site-packages:$PYTHONPATH"
export GPG_TTY=$(tty)
export HISTSIZE=1000
export HISTFILESIZE=2000


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
eval "$(mcfly init bash)"
eval "$(zoxide init bash)"