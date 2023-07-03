[ -s "$HOME/.commonrc" ] && source "$HOME/.commonrc"

# Make tab-complation act more like bash (no auto-insert)
setopt nomenucomplete

NEWLINE=$'\n'
export PROMPT="${NEWLINE}%F{green}%n@%m %F{yellow}%1~/ %F{white}%(0?..%K{red}%?%k )${NEWLINE}%F{white}"'%(!.#.$) '

# Vim mode quashes C-R history searching
bindkey '^r' history-incremental-search-backward
