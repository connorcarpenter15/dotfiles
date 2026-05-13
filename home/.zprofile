[ -r "$HOME/.profile" ] && source "$HOME/.profile"

_zprofile_prepend_path() {
  [ -d "$1" ] || return

  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

# Optional machine-local tools.
_zprofile_prepend_path /usr/local/smlnj/bin
_zprofile_prepend_path "$HOME/depot_tools"
_zprofile_prepend_path "$HOME/miniconda3/bin"
_zprofile_prepend_path "$HOME/anaconda3/bin"
_zprofile_prepend_path /opt/homebrew/miniconda3/bin
_zprofile_prepend_path /opt/homebrew/anaconda3/bin
_zprofile_prepend_path /usr/local/miniconda3/bin
_zprofile_prepend_path /usr/local/anaconda3/bin

if [ -n "${DBUS_LAUNCHD_SESSION_BUS_SOCKET:-}" ]; then
  export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
fi

export PATH

unset -f _zprofile_prepend_path 2>/dev/null || true
