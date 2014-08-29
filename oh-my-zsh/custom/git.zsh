# change into git repo's top-level directory
alias gcd='cd $(git rev-parse --show-toplevel)'

# show age of branches
alias branchages='for k in `git branch -r|sed -e"s/ ->.*//"|sed s/^..//`;do echo -e `git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" "$k" --`\\t"$k";done|sort -r'

# replace git command with hub https://hub.github.com/
if [[ -n $(command -v hub) ]]; then
  alias git=hub
fi
