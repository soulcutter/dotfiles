# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

export HISTCONTROL="ignoreboth"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
  plugins=(git ssh-agent history-substring-search)
else
  # remove ssh-agent since it breaks Jetbrains shell integration
  # since it interactively prompts for ssh key passwords
  plugins=(git history-substring-search)
fi

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
unsetopt correct_all # turn off autocorrect completely

# setup initial path from /etc/paths in OSX
if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

export ANT_OPTS="-Xmx2048m"
export MAVEN_REPOSITORY="~/.m2"

if uname | grep -q Darwin ; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export EVENT_NOKQUEUE=1
  export HOMEBREW_NO_GOOGLE_ANALYTICS=1
  export HOMEBREW_NO_ANALYTICS=1
fi

# -F Exit immediately if content fits in a single page
# -R Colorize `less` output instead of printing color codes
# -X Prevent clear screen on init/exit
export LESS="-FRX"

export EDITOR="vim"

export AWS_REGION="us-east-1"

# When you don't prefer fuzzy matching and do not wish to "quote" every word
export FZF_DEFAULT_OPTS="--exact --height 80% --reverse"

if [ -x "$(command -v hub)" ]; then
  eval "$(hub alias -s)" # Aliases 'git' to the 'hub' command
fi

PATH=$PATH:/usr/local/sbin # add sbin to PATH for rabbitmq-server
[ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh" # asdf version manager needs this I guess
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
