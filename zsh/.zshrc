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
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "zap-zsh/zap-prompt"
# plug "zap-zsh/atmachine"
plug "zap-zsh/fzf"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"


# Keybinds for git auto-completion
# __git_complete ga _git_add
# __git_complete gd _git_diff
# __git_complete gb _git_branch
# __git_complete gch _git_checkout
# __git_complete gs _git_status
# __git_complete gc _git_commit
# __git_complete gl _git_log
# __git_complete gps _git_push
# __git_complete gpl _git_pull
# __git_complete gr _git_reset
# __git_complete grh _git_reset
# __git_complete gf _git_fetch
# __git_complete gw _git_worktree


# Point to executable in windows
alias obsidian='/mnt/c/Users/kinst/AppData/Local/Programs/obsidian/Obsidian.exe'


# Start SSH agent and add key if not already added
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi

# Use keychain to manage the SSH key
eval $(keychain --eval --agents ssh ~/.ssh/id_ed25519)


eval "$(starship init zsh)"
#eval "$(mcfly init zsh)"
#eval "$(zoxide init zsh)"
#eval "$(direnv hook zsh)"
