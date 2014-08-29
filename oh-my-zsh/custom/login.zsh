
function add-login() {
  if grep -qsE "^$1" .ssh-logins; then
    sed -i "" -e "s/`grep -E "^$1 " .ssh-logins`/$*/" .ssh-logins
  else
    echo $* >> .ssh-logins
  fi

  if [ -f .gitignore ]; then
    if ! grep -qE ".ssh-logins" .gitignore; then
      echo ".ssh-logins" >> .gitignore
    fi
  fi
}

function get-login() {
  local access=( `grep -E "^$1 " .ssh-logins` )
  echo ${access[1]}
}

function login() {
  ssh $(get-login "$1")
}
