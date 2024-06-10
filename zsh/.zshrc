#!/bin/sh
# If you come from bash you might have to change your $PATH.
# export PATH="$HOME/bin:/usr/local/bin:$PATH"


# Load Zap if installed
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# Source custom configuration files
plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/exports.zsh"
plug "$HOME/.config/zsh/functions.zsh"


# Zap Plugins
plug "esc/conda-zsh-completion"
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "zap-zsh/zap-prompt"
# plug "zap-zsh/atmachine"
plug "zap-zsh/fzf"
plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"


# Keybinds for git auto-completion
__git_complete ga _git_add
__git_complete gd _git_diff
__git_complete gb _git_branch
__git_complete gch _git_checkout
__git_complete gs _git_status
__git_complete gc _git_commit
__git_complete gl _git_log
__git_complete gps _git_push
__git_complete gpl _git_pull
__git_complete gr _git_reset
__git_complete grh _git_reset
__git_complete gf _git_fetch
__git_complete gw _git_worktree


eval "$(starship init zsh)"
#eval "$(mcfly init zsh)"
#eval "$(zoxide init zsh)"
#eval "$(direnv hook zsh)"
