# Interactive Bash only
case $- in
*i*) ;;
*) return ;;
esac

# Shared aliases and environment
[ -r "$HOME/.shellrc" ] && . "$HOME/.shellrc"
[ -r "$HOME/.secrets" ] && . "$HOME/.secrets"
alias so='source ~/.bashrc'

# Completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# Shell integrations
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash --cmd j)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# Prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# nvsec aws assume shell integration
source /home/connorc/.nvsec/shell.sh
