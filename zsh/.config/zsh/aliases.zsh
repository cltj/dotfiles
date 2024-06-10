# My aliases


# cd
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'


# Poetry
alias poetry-rebuild='poetry env remove --all && poetry install'
alias pru="poetry run"
alias psh="poetry shell"
alias pad="poetry add"
alias pin="poetry install"
alias plo="poetry lock"
alias plof="trash poetry.lock && poetry lock"
alias plofi="trash poetry.lock && poetry install"
alias pen="poetry env"
alias peni="poetry env info"
alias penl="poetry env list"
alias penu="poetry env use python"
alias penr="poetry env remove --all"
alias penru="poetry env remove --all && poetry env use python"
alias penrui="poetry env remove --all && poetry env use python && poetry install"


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
alias t="poetry run pytest"
alias ts="pytest --log-cli-level=100 -p no:warnings"
alias py="python3"
alias zellij="./zellij"


if command -v bat &> /dev/null; then
  alias cat="bat -pp --theme \"Visual Studio Dark+\"" 
  alias catt="bat --theme \"Visual Studio Dark+\"" 
fi
