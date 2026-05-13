# Shared login-shell environment.

_profile_setup_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    return
  fi

  for brew in \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew \
    "$HOME/.linuxbrew/bin/brew"
  do
    if [ -x "$brew" ]; then
      eval "$("$brew" shellenv)"
      return
    fi
  done
}

_profile_setup_homebrew

[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

export PATH

unset -f _profile_setup_homebrew 2>/dev/null || true
