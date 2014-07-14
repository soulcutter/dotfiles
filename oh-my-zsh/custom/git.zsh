# change into git repo's top-level directory
alias gcd='cd $(git rev-parse --show-toplevel)'

# replace git command with hub https://hub.github.com/
if [[ -n $(command -v hub) ]]; then
  alias git=hub
fi
