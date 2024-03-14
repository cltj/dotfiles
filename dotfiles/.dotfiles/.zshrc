# If you come from bash you might have to change your $PATH.
# export PATH="$HOME/bin:/usr/local/bin:$PATH"

. ~/.dotfiles/.commonrc

export PATH="~/.local/bin/poetry:$PATH"
export PATH="~/.local/bin:$PATH"
export GPG_TTY=$(tty)
export GCM_CREDENTIAL_STORE="gpg"
export GCM_PROVIDER="azure-repos"
export GCM_AZREPOS_CREDENTIALTYPE="pat"
export HISTSIZE=1000
export HISTFILESIZE=2000

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# Path to your oh-my-zsh installation.
export ZSH="~/.oh-my-zsh"
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
HIST_STAMPS="yyyy-mm-dd"
zstyle ':omz:update' mode auto
# Standard plugins is in $ZSH/plugins/ 
# More: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(git gh fzf pip python poetry poetry-env starship)
. "$ZSH/oh-my-zsh.sh"

eval "$(starship init zsh)"