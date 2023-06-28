[ -s "$HOME/.commonrc" ] && source "$HOME/.commonrc"

NEWLINE=$'\n'
export PROMPT="${NEWLINE}%F{green}%n@%m %F{yellow}%1~/ %F{red}%(0?..%? )%F{white}${NEWLINE}"'%(!.#.$) '
