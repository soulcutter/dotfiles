#!/usr/bin/env zsh

# Checks if a 1Password CLI plugin is initialized
function op_plugin_configured() {
  local dir="${OP_PLUGIN_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/op}/plugins"
  [[ -s "$dir/$1.json" ]]
}

# Does `op read` with error handling
# Usage: VALUE=$(op_read "op://Vault/Item/field") || return 1
function op_read() {
  local ref="$1" value rc caller="${funcstack[2]:-op_read}"

  value=$(op read "$ref" 2>&1)
  rc=$?

  if (( rc != 0 )) || [[ -z "$value" ]]; then
    if [[ -n "$value" ]]; then
      # op prefixes its messages with "[ERROR] YYYY/MM/DD HH:MM:SS "; drop that noise.
      echo "$value" \
        | sed -E 's/^\[(ERROR|FATAL|WARN|INFO)\] [0-9]{4}\/[0-9]{2}\/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} //' \
        | sed "s/^/[$caller]   Error: /" >&2
    else
      echo "[$caller]   Error: failed to read \"$ref\" from 1Password." >&2
    fi
    return 1
  fi

  print -r -- "$value"
}

function op_login() {
  local failed=0

  op_login_github || failed=1
  op_login_npm || failed=1
  op_login_datadog || failed=1
  op_login_eng_artifactory || failed=1
  op_login_confluence || failed=1
  op_login_claude || failed=1

  if (( failed )); then
    echo "[op_login] Error: one or more logins failed." >&2
    return 1
  fi
}

function op_login_circleci() {
  echo "[op_login_circleci] Setting up CircleCI credentials from 1Password..."
  CIRCLE_TOKEN=$(op_read "op://Private/CircleCI API Key 2024 StitchFix MBP CLI/password") || return 1
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

  GITHUB_TOKEN=$(op_read "op://Private/GitHub Personal Access Token/credential") || return 1
  GH_TOKEN=$(op_read "op://Private/GitHub Personal Access Token/credential") || return 1
  GH_USERNAME=$(op_read "op://Private/GitHub Personal Access Token/username") || return 1
  export GITHUB_TOKEN
  export GH_TOKEN
  export GH_USERNAME

  echo "[op_login_github] Setup Complete."
}

function op_login_npm() {
  # Export NPM token
  echo "[op_login_npm] Setting up NPM credentials from 1Password..."
  NPM_TOKEN=$(op_read "op://Private/Npmjs/token") || return 1
  export NPM_TOKEN
  echo "[op_login_npm] Setup Complete."
}

function op_login_datadog() {
  # Export Datadog API and application keys
  echo "[op_login_datadog] Setting up DataDog API credentials from 1Password..."
  DD_APP_KEY=$(op_read "op://Private/Datadog/Application Key") || return 1
  DD_API_KEY=$(op_read "op://Private/Datadog/Api Key") || return 1
  export DD_APP_KEY
  export DD_API_KEY
  export DD_APPLICATION_KEY=$DD_APP_KEY
  echo "[op_login_datadog] Setup Complete."
}

function op_login_confluence() {
  echo "[op_login_confluence] Setting up Confluence credentials from 1Password..."
  ATLASSIAN_API_TOKEN=$(op_read "op://Private/Atlassian Confluence/API Key") || return 1
  ATLASSIAN_EMAIL="bradley.schaefer@stitchfix.com"
  export ATLASSIAN_API_TOKEN
  export ATLASSIAN_EMAIL
  echo "[op_login_confluence] Setup Complete."
}

function op_login_algo_artifactory() {
  echo "[op_login_algo_artifactory] Setting up Algo Artifactory credentials from 1Password..."
  UV_INDEX_URL=$(op_read "op://Private/Algo Artifactory/Index URL") || return 1
  UV_INDEX_USERNAME=$(op_read "op://Private/Algo Artifactory/Username") || return 1
  UV_INDEX_PASSWORD=$(op_read "op://Private/Algo Artifactory/Password") || return 1
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
  UV_INDEX_URL=$(op_read "op://Private/Eng Artifactory/Index URL") || return 1
  UV_INDEX_USERNAME=$(op_read "op://Private/Eng Artifactory/Username") || return 1
  UV_INDEX_PASSWORD=$(op_read "op://Private/Eng Artifactory/Password") || return 1
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

  local base_url auth_token custom_headers opus_model sonnet_model haiku_model

  base_url=$(op_read "op://Private/StitchFix Claude/base url") || return 1
  auth_token=$(op_read "op://Private/StitchFix Claude/api key") || return 1
  custom_headers=$(op_read "op://Private/StitchFix Claude/custom headers") || return 1

  # IDK why folks think it's important to set these explicitly rather than depending
  # on defaults, but I'm told this is a recommendation and so I'm doing it.  ¯\_(ツ)_/¯
  opus_model=$(op_read "op://Private/StitchFix Claude/opus model") || return 1
  sonnet_model=$(op_read "op://Private/StitchFix Claude/sonnet model") || return 1
  haiku_model=$(op_read "op://Private/StitchFix Claude/haiku model") || return 1

  export ANTHROPIC_BASE_URL="$base_url"
  export ANTHROPIC_AUTH_TOKEN="$auth_token"
  export AWS_BEARER_TOKEN_BEDROCK="$auth_token"
  export ANTHROPIC_CUSTOM_HEADERS="$custom_headers"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="$opus_model"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="$sonnet_model"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="$haiku_model"

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
