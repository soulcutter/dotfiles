#!/bin/bash

# Make sure oh-my-zsh exists
if ! [ -d ~/.oh-my-zsh ]; then
  echo "oh-my-zsh not detected - installing now..."
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# Install Vundle
if ! [ -d ~/.vim/bundle ]; then
  echo "Vundle (vim package manager) not detected - installing now..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall # install Vundle vim plugins

# Make sure submodules are init
echo "initializing submodules..."
git submodule update --quiet --init --recursive > /dev/null

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
oh-my-zsh/custom/*.zsh
"

BIN="
resolve-schema
safe-reattach-to-user-namespace
"

# Create symbolic links for all configuration files
echo "symlinking dotfiles to $HOME"
for file_pattern in $FILES
do
  for file in ${file_pattern}; do
    [ -e "$file" ] || continue
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
        # force unlinking because OSX's -h option is not portable
        if [ -L "$TARGET" ]; then
          unlink "$TARGET"
        fi
        ln -fsv "$SOURCE" "$TARGET"
        ;;
    esac
  done
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

