#!/bin/bash

# Get the source directory
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install xcode
echo ">> Installing xcode in the system"
xcode-select --install

# Install homebrew
echo ">> Installing homebrew in the system"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install brew dependencies
echo ">> Installing brew dependencies"
brew bundle --file="$SOURCE_DIR/Brewfile"

# Install oh my fish
echo ">> Install oh my fish"
curl -L https://get.oh-my.fish > install
fish install --path=~/.local/share/omf --config=~/.config/fish/omf

# Upgrade pip
echo ">> Upgrading pip version"
sudo pip install --user --upgrade pip

# Install virtual environment
echo ">> Install virtual environment"
pip install --user --upgrade virtualenv

# Configure mySQL
brew tap homebrew/services
brew services start mysql
brew link mysql --force
mysql -V
