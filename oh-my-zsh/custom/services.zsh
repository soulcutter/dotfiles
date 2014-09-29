if [[ "$OSTYPE" == "darwin"* ]]; then
  function pgstart() {
    echo "Starting postgresql"
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
  }
  function pgstop() {
    echo "Stopping postgresql"
    launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
  }
fi
