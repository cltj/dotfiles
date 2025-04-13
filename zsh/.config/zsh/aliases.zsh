# My aliases


# cd
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'



# git aliases
alias ga="git add"
alias gd="git diff"
alias gds="git diff --staged"
alias gb="git branch"
alias gba="git branch -a"
alias gch="git checkout"
alias gs="git status"
alias gc="git commit"
alias gl="git log"
alias glo="git log --oneline --graph"
alias gps="git push"
alias gpl="git pull"
alias gr="git reset"
alias grh="git reset --hard"
alias gf="git fetch"
alias gsu="git submodule init && git submodule update"
alias gamend="git commit --amend --no-edit"
alias gforce="git push --force-with-lease"
alias grm="git ls-files -c --ignored --exclude-standard -z | xargs -0 git rm --cached"
alias gw="git worktree"
alias gwl="git worktree list"
alias gcar="git config --add remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'"


# Others
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias now='date +"%s"'
alias grep="grep --color=auto"
alias re-source='. ~/.zshrc 2>/dev/null ; . ~/.bashrc 2>/dev/null'
alias ts="pytest --log-cli-level=100 -p no:warnings"
alias py="python3"
alias zellij="./zellij"


if command -v bat &> /dev/null; then
  alias cat="bat -pp --theme \"Visual Studio Dark+\"" 
  alias catt="bat --theme \"Visual Studio Dark+\"" 
fi
