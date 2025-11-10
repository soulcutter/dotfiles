function op_login() {
  op_login_github
  op_login_npm
  op_login_datadog
}

function op_login_github() {
  # Export GitHub credentials
  echo "[op_login_github] Setting up GitHub credentials from 1Password..."
  export GITHUB_TOKEN=`op read "op://Private/GitHub Personal Access Token/token"`
  export GH_TOKEN=`op read "op://Private/GitHub Personal Access Token/token"`
  export GH_USERNAME=`op read "op://Private/GitHub Personal Access Token/username"`
  echo "[op_login_github] Setup Complete."
}

function op_login_npm() {
  # Export NPM token
  echo "[op_login_npm] Setting up NPM credentials from 1Password..."
  export NPM_TOKEN=`op read "op://Private/Npmjs/token"`
  echo "[op_login_npm] Setup Complete."
}

function op_login_datadog() {
  # Export Datadog API and application keys
  echo "[op_login_datadog] Setting up DataDog API credentials from 1Password..."
  export DD_APP_KEY=`op read "op://Private/Datadog/Application Key"`
  export DD_API_KEY=`op read "op://Private/Datadog/Api Key"`
  echo "[op_login_datadog] Setup Complete."
}


function add-login() {
  if grep -qsE "^$1" .ssh-logins; then
    sed -i "" -e "s/`grep -E "^$1 " ~/.ssh-logins`/$*/" ~/.ssh-logins
  else
    echo $* >> ~/.ssh-logins
  fi

  if [ -f .gitignore ]; then
    if ! grep -qE "~/.ssh-logins" .gitignore; then
      echo "~/.ssh-logins" >> .gitignore
    fi
  fi
}

function get-login() {
  grep -E "^$1 " ~/.ssh-logins | awk '{ print $2 }'
}

function login() {
  ssh $(get-login "$1")
}
