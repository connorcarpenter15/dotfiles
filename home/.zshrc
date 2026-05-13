# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list '' \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# Shared aliases and environment
[ -r "$HOME/.shellrc" ] && source "$HOME/.shellrc"
alias so='source ~/.zshrc'

# Shell integrations
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd j)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# FZF widgets
fzf_history_search() {
  local selected
  selected=$(history | fzf --tac | sed 's/ *[0-9]* *//')

  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
  fi

  zle reset-prompt
}
zle -N fzf_history_search

fzf_nvim_open() {
  local selected
  selected=$(fd --type f --type l --hidden --exclude .git . | fzf)

  if [[ -n "$selected" ]]; then
    nvim "$selected"
  fi

  zle reset-prompt
}
zle -N fzf_nvim_open

fzf_zoxide_cd() {
  local selected
  local open_nvim="$1"

  selected=$(zoxide query --list | fzf)
  if [[ -n "$selected" ]]; then
    cd "$selected" || return

    if [[ "$open_nvim" == "true" ]]; then
      nvim -c "lua require('persistence').load()"
    fi
  fi

  zle reset-prompt
}
zle -N fzf_zoxide_cd

fzf_zoxide_load() {
  fzf_zoxide_cd true
}
zle -N fzf_zoxide_load

fg_widget() {
  fg 2>/dev/null
  zle reset-prompt
}
zle -N fg_widget

# Key bindings
bindkey '^N' down-history
bindkey '^P' up-history
bindkey '^E' end-of-line
bindkey '^A' beginning-of-line

bindkey '^R' fzf_history_search
bindkey '^O' fzf_nvim_open
bindkey '^J' fzf_zoxide_cd
bindkey '^F' fzf_zoxide_load
bindkey '^Z' fg_widget
bindkey '^[^?' kill-whole-line

# Syntax highlighting should load after widgets are defined.
if command -v brew >/dev/null 2>&1; then
  zsh_syntax_highlighting="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [ -r "$zsh_syntax_highlighting" ] && source "$zsh_syntax_highlighting"
  unset zsh_syntax_highlighting
fi

# Prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
