function sunglasses() { echo -en "( •_•)   \r"; sleep .5; echo -en " ( •_•)>⌐■-■\r"; sleep 1; echo " (⌐■_■)     ";  sleep 1; echo "Deal with it"; }

function ftfc() {
    sudo killall VDCAssistant;
    sudo killall AppleCameraAssistant;
}

#alias op_login_github='export GITHUB_TOKEN=$(op read "op://Private/GitHub Personal Access Token/token") GH_TOKEN=$(op read "op://Private/GitHub Personal Access Token/token") GH_USERNAME=$(op read "op://Private/GitHub Personal Access Token/username")'

function setup_dd_env() {
  # Export Datadog API and application keys
  echo "[setup_dd_env] Setting up DataDog API credentials from 1Password..."
  export DD_APP_KEY=`op read "op://Private/Datadog/Application Key"`
  export DD_API_KEY=`op read "op://Private/Datadog/Api Key"`
  echo "[setup_dd_env] Setup Complete."
}
