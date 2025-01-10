# Make tab-complation act more like bash (no auto-insert)
setopt nomenucomplete

# Autocompletion fun.
autoload -Uz compinit
compinit
autoload bashcompinit
bashcompinit

# Kubectl autocomplete
if [ -x /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi
# alias k=kubectl; complete -F __start_kubectl k

[ -s "$HOME/.commonrc" ] && source "$HOME/.commonrc"

# Prompt
setopt PROMPT_SUBST  # Allow $(...) expansion in prompt
NEWLINE=$'\n'
export PROMPT="${NEWLINE}%F{green}%n@%m %F{yellow}%1~/ %F{cyan}"'$(isgitrepo 2>&1 > /dev/null && (git symbolic-ref --quiet --short HEAD || echo "(detached head)"))'" %F{white}%(0?..%K{red}%?%k )${NEWLINE}%F{white}"'%(!.#.$) '

# Vim mode quashes C-R history searching
bindkey '^r' history-incremental-search-backward

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
