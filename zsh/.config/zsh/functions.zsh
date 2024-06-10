# Zsh functions


j() {
    if [ -z "$2" ]
    then
        cd ~/projects/"$1"
    else
        cd ~/projects/"$1"/"$2"
    fi
}

j_complete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}
    
    if [[ $COMP_CWORD -eq 1 ]] ; then
        COMPREPLY=( $(compgen -W "$(ls ~/projects/)" -- $cur) )
    elif [[ $COMP_CWORD -eq 2 ]] ; then
        local IFS=$'\n'
        local worktrees=( $(cd ~/projects/"$prev" && git worktree list | awk 'NR>1{print $1}' | sed -e "s|^${HOME}/projects/${prev}/||") )
        COMPREPLY=( $(compgen -W "${worktrees[*]}" -- $cur) )
    fi
}
complete -F j_complete j

jw() {
    is_bare=$(git rev-parse --is-bare-repository)

    if [ "$is_bare" == "true" ]; then
        cd "./$1"
    else
        cd "../$1"
    fi
}

jw_complete() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local worktrees=( $(git worktree list | grep -v '(bare)' | awk -F'/' '{print $NF}' | awk '{print $1}') )
    COMPREPLY=( $(compgen -W "${worktrees[*]}" -- $cur) )
}
complete -F jw_complete jw

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
