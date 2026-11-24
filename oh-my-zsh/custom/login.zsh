#!/usr/bin/env zsh

# Checks if a 1Password CLI plugin is initialized
function op_plugin_configured() {
  local dir="${OP_PLUGIN_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/op}/plugins"
  [[ -s "$dir/$1.json" ]]
}

function op_login() {
  op_login_github
  op_login_npm
  op_login_datadog
  op_login_eng_artifactory
  op_login_confluence
  op_login_claude
}

function op_login_circleci() {
  echo "[op_login_circleci] Setting up CircleCI credentials from 1Password..."
  CIRCLE_TOKEN=$(op read "op://Private/CircleCI API Key 2024 StitchFix MBP CLI/password")
  CIRCLE_CI_PACTS_API_TOKEN="$CIRCLE_TOKEN"
  export CIRCLE_TOKEN
  export CIRCLE_CI_PACTS_API_TOKEN
  echo "[op_login_circleci] Setup complete."
}

function op_login_github() {
  # Export GitHub credentials
  echo "[op_login_github] Setting up GitHub credentials from 1Password..."

  if op_plugin_configured gh; then
    if [[ "$(whence -w gh 2>/dev/null)" == *function ]]; then
      echo "[op_login_github]   1Password gh plugin is configured and aliases are sourced"
    else
      echo "[op_login_github]   1Password gh plugin is configured, but the gh wrapper is not loaded"
      echo "[op_login_github]   Consider running: source \"\${HOME}/.config/op/plugins.sh\""
    fi
  else
    echo "[op_login_github]   1Password gh plugin is not configured"
    echo "[op_login_github]   Consider running: op plugin init gh"
  fi

  GITHUB_TOKEN=$(op read "op://Private/GitHub Personal Access Token/credential")
  GH_TOKEN=$(op read "op://Private/GitHub Personal Access Token/credential")
  GH_USERNAME=$(op read "op://Private/GitHub Personal Access Token/username")
  export GITHUB_TOKEN
  export GH_TOKEN
  export GH_USERNAME

  echo "[op_login_github] Setup Complete."
}

function op_login_npm() {
  # Export NPM token
  echo "[op_login_npm] Setting up NPM credentials from 1Password..."
  NPM_TOKEN=$(op read "op://Private/Npmjs/token")
  export NPM_TOKEN
  echo "[op_login_npm] Setup Complete."
}

function op_login_datadog() {
  # Export Datadog API and application keys
  echo "[op_login_datadog] Setting up DataDog API credentials from 1Password..."
  DD_APP_KEY=$(op read "op://Private/Datadog/Application Key")
  DD_API_KEY=$(op read "op://Private/Datadog/Api Key")
  export DD_APP_KEY
  export DD_API_KEY
  export DD_APPLICATION_KEY=$DD_APP_KEY
  echo "[op_login_datadog] Setup Complete."
}

function op_login_confluence() {
  echo "[op_login_confluence] Setting up Confluence credentials from 1Password..."
  ATLASSIAN_API_TOKEN=$(op read "op://Private/Atlassian Confluence/API Key")
  ATLASSIAN_EMAIL="bradley.schaefer@stitchfix.com"
  export ATLASSIAN_API_TOKEN
  export ATLASSIAN_EMAIL
  echo "[op_login_confluence] Setup Complete."
}

function op_login_algo_artifactory() {
  echo "[op_login_algo_artifactory] Setting up Algo Artifactory credentials from 1Password..."
  UV_INDEX_URL=$(op read "op://Private/Algo Artifactory/Index URL")
  UV_INDEX_USERNAME=$(op read "op://Private/Algo Artifactory/Username")
  UV_INDEX_PASSWORD=$(op read "op://Private/Algo Artifactory/Password")
  export UV_INDEX_URL
  export UV_INDEX_USERNAME
  export UV_INDEX_PASSWORD
  # different env variable names for different tools/setups
  export UV_INDEX_STITCHPY_URL=$UV_INDEX_URL
  export UV_INDEX_STITCHPY_USERNAME=$UV_INDEX_USERNAME
  export UV_INDEX_STITCHPY_PASSWORD=$UV_INDEX_PASSWORD
  export ARTIFACTORY_USER=$UV_INDEX_USERNAME
  export ARTIFACTORY_TOKEN=$UV_INDEX_PASSWORD
  export UV_DEFAULT_INDEX=$UV_INDEX_URL

  DOMAIN=$(echo "$UV_INDEX_URL" | sed -E 's|https?://([^/]+).*|\1|')
  export UV_DEFAULT_INDEX="https://${UV_INDEX_USERNAME}:${UV_INDEX_PASSWORD}@${DOMAIN}/artifactory/api/pypi/stitchpy/simple"

  echo "[op_login_algo_artifactory] Setup Complete."
}

function op_login_eng_artifactory() {
  echo "[op_login_eng_artifactory] Setting up Eng Artifactory credentials from 1Password..."
  UV_INDEX_URL=$(op read "op://Private/Eng Artifactory/Index URL")
  UV_INDEX_USERNAME=$(op read "op://Private/Eng Artifactory/Username")
  UV_INDEX_PASSWORD=$(op read "op://Private/Eng Artifactory/Password")
  export UV_INDEX_URL
  export UV_INDEX_USERNAME
  export UV_INDEX_PASSWORD
  # different env variable names for different tools/setups
  export UV_INDEX_STITCHPY_URL=$UV_INDEX_URL
  export UV_INDEX_STITCHPY_USERNAME=$UV_INDEX_USERNAME
  export UV_INDEX_STITCHPY_PASSWORD=$UV_INDEX_PASSWORD
  export ARTIFACTORY_USER=$UV_INDEX_USERNAME
  export ARTIFACTORY_TOKEN=$UV_INDEX_PASSWORD
  DOMAIN=$(echo "$UV_INDEX_URL" | sed -E 's|https?://([^/]+).*|\1|')
  export UV_DEFAULT_INDEX="https://${UV_INDEX_USERNAME}:${UV_INDEX_PASSWORD}@${DOMAIN}/artifactory/api/pypi/stitchpy/simple"

  echo "[op_login_eng_artifactory] Setup Complete."
}

function op_login_claude() {
  echo "[op_login_claude] Setting up Claude credentials from 1Password..."

  export ANTHROPIC_BASE_URL=$(op read "op://Private/StitchFix Claude/base url")
  export ANTHROPIC_AUTH_TOKEN=$(op read "op://Private/StitchFix Claude/api key")
  export AWS_BEARER_TOKEN_BEDROCK=$ANTHROPIC_AUTH_TOKEN
  export ANTHROPIC_CUSTOM_HEADERS=$(op read "op://Private/StitchFix Claude/custom headers")

  # IDK why folks think it's important to set these explicitly rather than depending
  # on defaults, but I'm told this is a recommendation and so I'm doing it.  ¯\_(ツ)_/¯
  export ANTHROPIC_DEFAULT_OPUS_MODEL=$(op read "op://Private/StitchFix Claude/opus model")
  export ANTHROPIC_DEFAULT_SONNET_MODEL=$(op read "op://Private/StitchFix Claude/sonnet model")
  export ANTHROPIC_DEFAULT_HAIKU_MODEL=$(op read "op://Private/StitchFix Claude/haiku model")

  # export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
  export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1

  echo "[op_login_claude] Setup Complete."
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
