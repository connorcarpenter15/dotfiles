# Shared login-shell environment.

_profile_source_if_readable() {
  [ -r "$1" ] && . "$1"
}

_profile_setup_nix() {
  if [ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  elif [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
}

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

_profile_setup_home_manager() {
  _profile_source_if_readable "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

  if [ -n "${USER:-}" ]; then
    _profile_source_if_readable "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
  fi
}

_profile_setup_nix
_profile_setup_homebrew
_profile_setup_home_manager

[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

_profile_prepend_path_if_dir "$HOME/bin"
_profile_prepend_path_if_dir "$HOME/.local/bin"

[ -r "$HOME/.profile.local" ] && . "$HOME/.profile.local"

export PATH

unset -f _profile_source_if_readable _profile_setup_nix _profile_setup_homebrew _profile_setup_home_manager _profile_prepend_path _profile_prepend_path_if_dir 2>/dev/null || true
