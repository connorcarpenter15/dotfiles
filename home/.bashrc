# Initialize Starship prompt for interactive Bash shells.
case $- in
  *i*) ;;
  *) return ;;
esac

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
