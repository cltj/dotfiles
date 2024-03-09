# If you come from bash you might have to change your $PATH.
# export PATH="$HOME/bin:/usr/local/bin:$PATH"

. ~/.dotfiles/.commonrc

export PATH="/home/tj/.local/bin/poetry:$PATH"
#export PATH="/home/tj/.cache/pypoetry/virtualenvs/fka-databricks-GAMMsPWM-py3.10/bin/python:$PATH"
#export PYTHONPATH="/home/tj/.cache/pypoetry/virtualenvs/fka-databricks-GAMMsPWM-py3.10/lib/python3.10/site-packages:$PYTHONPATH"
export PATH="$HOME/.local/bin:$PATH"
export HISTSIZE=1000
export SAVEHIST=2000

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
eval "$(mcfly init zsh)"
eval "$(zoxide init zsh)"