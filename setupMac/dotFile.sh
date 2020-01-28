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
echo ">> Start mySQL services"
brew tap homebrew/services
brew services start mysql
brew link mysql --force
mysql -V

# Configure vim environment
echo ">> Configuring vim environment"
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# Update vim plugins
git pull --rebase
python update_plugins.py

# Install aws-cli
curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-macos.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
which aws2

# Install sshpass
brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb

# Default shell
SHELL_VAL=`echo ${SHELL}`

# Create shell configuration file based on default system shell
env_config () {
  if [ $SHELL_VAL = '/bin/zsh' ]
  then
      touch .zshrc
      echo ">>.zshrc file created"
  elif [ $SHELL_VAL = '/bin/bash' ]
  then
      touch .bash_profile
      echo ">>.bash_profile file created"
  else
    echo ">>Valid shell not present"
  fi
}

bash_sshpass () {
  echo "alias $alias_val='sshpass -p $password ssh $ip_add'" >> .bash_profile
  echo ">>sshpass configuration done for .bash_profile"
}

zsh_sshpass () {
  echo "alias $alias_val='sshpass -p $password ssh $ip_add'" >> .zshrc
  echo ">>sshpass configuration done for .zshrc"
}

echo "Configure sshpass? (Y/N) "
read option
if [ $option = "Y" ]
then
  echo "Enter user password: "
  read password
  echo "Enter ssh address: "
  read ip_add
  echo "Enter alias value to be set in shell config file: "
  read alias_val
  if [ $SHELL_VAL = "/bin/zsh" ]
  then
    env_config
    zsh_sshpass
  fi
  if [ $SHELL_VAL = "/bin/bash" ]
  then
    env_config
    bash_sshpass
  fi
elif [ $option = "N" ]
then
  echo ">>Skipping sshpass configuration and setting up shell configuration file"
  env_config
else
  echo ">>Invalid option"
fi
