[ -s "$HOME/.commonrc" ] && source "$HOME/.commonrc"

# Make tab-complation act more like bash (no auto-insert)
setopt nomenucomplete

# Prompt
setopt PROMPT_SUBST  # Allow $(...) expansion in prompt
NEWLINE=$'\n'
export PROMPT="${NEWLINE}%F{green}%n@%m %F{yellow}%1~/ %F{cyan}"'$(isgitrepo 2>&1 > /dev/null && git symbolic-ref --quiet --short HEAD || echo "(detached head)")'" %F{white}%(0?..%K{red}%?%k )${NEWLINE}%F{white}"'%(!.#.$) '


# Vim mode quashes C-R history searching
bindkey '^r' history-incremental-search-backward
