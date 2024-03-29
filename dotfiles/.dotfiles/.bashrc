if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
fi

if [ -f /etc/bash_completion.d/git ]; then
    . /etc/bash_completion.d/git
fi

. ~/.dotfiles/.commonrc

export PATH="~/.local/bin/poetry:$PATH"
export PATH="~/.local/bin:$PATH"
export GPG_TTY=$(tty)
export GCM_CREDENTIAL_STORE="gpg"
export GCM_PROVIDER="azure-repos"
export GCM_AZREPOS_CREDENTIALTYPE="pat"
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