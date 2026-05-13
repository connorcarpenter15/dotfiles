[ -r "$HOME/.profile" ] && . "$HOME/.profile"

_bash_profile_setup_conda() {
  if command -v conda >/dev/null 2>&1; then
    __conda_setup="$(conda shell.bash hook 2>/dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    fi
    unset __conda_setup
    return
  fi

  for conda_base in \
    "$HOME/miniconda3" \
    "$HOME/anaconda3" \
    /opt/homebrew/anaconda3 \
    /opt/homebrew/miniconda3 \
    /usr/local/anaconda3 \
    /usr/local/miniconda3
  do
    if [ -x "$conda_base/bin/conda" ]; then
      __conda_setup="$("$conda_base/bin/conda" shell.bash hook 2>/dev/null)"
      if [ $? -eq 0 ]; then
        eval "$__conda_setup"
      fi
      unset __conda_setup
      return
    fi

    if [ -r "$conda_base/etc/profile.d/conda.sh" ]; then
      . "$conda_base/etc/profile.d/conda.sh"
      return
    fi
  done
}

_bash_profile_setup_conda
unset -f _bash_profile_setup_conda 2>/dev/null || true

[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
