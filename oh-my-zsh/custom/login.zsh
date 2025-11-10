
alias op_login='op_login_github && op_login_npm'
alias op_login_github='export GITHUB_TOKEN=$(op read "op://Private/GitHub Personal Access Token/token") GH_TOKEN=$(op read "op://Private/GitHub Personal Access Token/token") GH_USERNAME=$(op read "op://Private/GitHub Personal Access Token/username")'
alias op_login_npm='export NPM_TOKEN=$(op read "op://Private/Npmjs/token")'

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
