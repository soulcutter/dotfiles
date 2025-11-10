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
plugins=(git history-substring-search mise)

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
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_ENV_HINTS=1
fi

export PACT_DO_NOT_TRACK=true

# -F Exit immediately if content fits in a single page
# -R Colorize `less` output instead of printing color codes
# -X Prevent clear screen on init/exit
export LESS="-FRX"

export EDITOR="vim"

export AWS_REGION="us-east-1"

# When you don't prefer fuzzy matching and do not wish to "quote" every word
export FZF_DEFAULT_OPTS="--exact --height 80% --reverse"
source <(fzf --zsh)

# Activate mise automatically
# you'd think the oh-my-zsh mise plugin would always do this
# but it seems like not
if command -v mise &> /dev/null; then
  exec $(mise activate zsh)
fi

[ -f "$HOME/.config/op/plugins.sh" ] && source "$HOME/.config/op/plugins.sh"
# [ -f "$HOME/.asdf/plugins/golang/set-env.zsh" ] && . "$HOME/.asdf/plugins/golang/set-env.zsh"
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"
export PATH="/opt/homebrew/bin:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/bin/pkg-config:$(brew --prefix icu4c)/lib/pkgconfig:$(brew --prefix curl)/lib/pkgconfig:$(brew --prefix zlib)/lib/pkgconfig"

# For compilers to find libpq (postgres client libraries) you may need to set:
# export LDFLAGS="-L$(brew --prefix libpq)/lib"
# export CPPFLAGS="-I$(brew --prefix libpq)/include"
# export PATH="$(brew --prefix libpq)/bin:$PATH"

# For pkg-config to find libpq you may need to set:
# export PKG_CONFIG_PATH="$(brew --prefix libpq)/lib/pkgconfig:$PKG_CONFIG_PATH"

if [[ -d "$HOME/projects" ]]; then
  export CDPATH=".:$HOME/projects"
fi
