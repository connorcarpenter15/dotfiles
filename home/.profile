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

_profile_prepend_path() {
  [ -n "$1" ] || return

  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

_profile_prepend_path_if_dir() {
  [ -d "$1" ] && _profile_prepend_path "$1"
}

_profile_setup_homebrew

[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

_profile_prepend_path_if_dir "$HOME/bin"
_profile_prepend_path_if_dir "$HOME/.local/bin"

[ -r "$HOME/.profile.local" ] && . "$HOME/.profile.local"

export PATH

unset -f _profile_setup_homebrew _profile_prepend_path _profile_prepend_path_if_dir 2>/dev/null || true
