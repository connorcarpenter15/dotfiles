# Load compinit for case-insensitive and substring completion
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh --cmd j)"

export EDITOR='nvim'

alias q='exit'
alias g='git'
alias e=yazi
alias l='ls -al'
alias ping='ping -c 10'
alias psa="btop -p 1"
alias so='source ~/.zshrc'
alias home='cd ~'
alias n=nvim
alias v='nvim'
alias pv='uv run nvim'
alias ns="nvim -c \"lua require('persistence').load()\""
alias rm='trash -v'
alias su='su - '
alias pwsh='pwsh.exe'
alias la="ls -a"
alias n.="nvim ."
alias gl="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'" # just use lazygit atp
alias lg='lazygit'
alias cp='cp -i'
alias gs='git status -s'
alias mv='mv -i'
alias ls="eza --color=always --icons=always --group-directories-first"
alias config="cd && cd .config/nvim && nvim"
alias "g++"="g++ -std=c++20"

alias mcserver="ssh -i .ssh/mudgies_server.key ubuntu@141.148.62.216"

fzf_history_search() {
  local selected
  selected=$(history | fzf --tac | sed 's/ *[0-9]* *//')
  if [ -n "$selected" ]; then
    BUFFER="$selected"
    zle reset-prompt
  else
    zle reset-prompt
  fi
}
zle -N fzf_history_search

fzf_nvim_open() {
  local selected
  selected=$(fd --type l --type f --hidden --exclude .git . | fzf)
  if [ -n "$selected" ]; then
    nvim "$selected"
    zle reset-prompt
  else
    zle reset-prompt
  fi
}
zle -N fzf_nvim_open


fzf_zoxide_cd() {
  local selected
  local open_nvim="$1"
  selected=$(zoxide query --list | fzf)
  if [ -n "$selected" ]; then
    cd "$selected"
    if [ "$open_nvim" = "true" ]; then
      nvim -c "lua require('persistence').load()"
    fi
    zle reset-prompt
  else
    zle reset-prompt
  fi
}
zle -N fzf_zoxide_cd

fzf_zoxide_load() {
  fzf_zoxide_cd true
}
zle -N fzf_zoxide_load

fg_widget() {
  fg
  zle reset-prompt
}
zle -N fg_widget

# these need to be redefined because they are removed with the zsh vim setting
bindkey '^N' down-history
bindkey '^P' up-history
bindkey '^E' end-of-line
bindkey '^A' beginning-of-line

bindkey '^R' fzf_history_search
bindkey '^O' fzf_nvim_open
bindkey '^J' fzf_zoxide_cd
bindkey '^F' fzf_zoxide_load
bindkey '^Z' fg_widget
bindkey '^[^?' kill-whole-line # clear line with M-BS or cmd-bs (mapped with alacritty)

# For direnv
eval "$(direnv hook zsh)"

# pnpm
export PNPM_HOME="/Users/cmaccarp/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Added by Antigravity
export PATH="/Users/cmaccarp/.antigravity/antigravity/bin:$PATH"

# Source zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Starship ---
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
