#!/bin/bash

# Make sure oh-my-zsh exists
if ! [ -d ~/.oh-my-zsh ]; then
  echo "oh-my-zsh not detected - installing now..."
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# Make sure submodules are init
echo "initializing submodules..."
git submodule update --init --recursive > /dev/null

# Set up directories
mkdir -p ~/.config/git

FILES="
gemrc
config/git/attributes
gitconfig
gitignore
zshrc
zprofile
irbrc
powconfig
pryrc
rspec
aprc
tmux
tmux.conf
tmux-linux
tmux-osx
vimrc
oh-my-zsh/custom/filesystem.zsh
oh-my-zsh/custom/git.zsh
oh-my-zsh/custom/login.zsh
oh-my-zsh/custom/tablexi.zsh
oh-my-zsh/custom/openssl.zsh
oh-my-zsh/custom/explain.zsh
oh-my-zsh/custom/postgresql.zsh
"

BIN="
resolve-schema
safe-reattach-to-user-namespace
"

# Create symbolic links for all configuration files
echo "symlinking dotfiles to $HOME"
for file in $FILES
do
  SOURCE="$HOME/dotfiles/$file"
  TARGET="$HOME/.$file"

  # Create backup file if the target already exists and is not a symlink
  if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "*** WARNING *** $TARGET already exists - copying original to .$file.old"
    mv "$TARGET" "$TARGET.old"
  fi

  case $OSTYPE in
    darwin*)
      ln -hfsv "$SOURCE" "$TARGET"
      ;;
    linux*)
      ln -fsv "$SOURCE" "$TARGET"
      ;;
  esac
done

# Create symbolic links for all bin files
for file in $BIN
do
  SOURCE="$HOME/dotfiles/bin/$file"
  TARGET="/usr/local/bin/$file"

  # Create backup file if the target already exists and is not a symlink
  if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "*** WARNING *** $TARGET already exists - copying original to .$file.old"
    mv "$TARGET" "$TARGET.old"
  fi

  case $OSTYPE in
    darwin*)
      ln -hfsv "$SOURCE" "$TARGET"
      ;;
    linux*)
      ln -fsv "$SOURCE" "$TARGET"
      ;;
  esac
done

exit 0

