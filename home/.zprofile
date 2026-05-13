eval "$(/opt/homebrew/bin/brew shellenv)"

# Add homebrew to beginning of PATH to overrride base macOS
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/smlnj/bin:"$PATH"
export PATH=/opt/homebrew/anaconda3/bin:"$PATH"
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

# Add depot tools to PATH for Chromium
export PATH="/Users/cmaccarp/depot_tools:$PATH"
