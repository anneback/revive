#!/bin/sh
myname="Firstname Lastname"
email="name@gmail.com"
echo "Creating an SSH key for you..."
ssh-keygen -t rsa -b 4096 -C $email
# Start the ssh-agent in the background.
eval "$(ssh-agent -s)"

touch ~/.ssh/config

echo "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config

# Add your SSH private key to the ssh-agent and store your passphrase in the keychain
ssh-add -K ~/.ssh/id_rsa

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
pbcopy < ~/.ssh/id_rsa.pub
echo "ssh key COPIED TO CLIPBOARD!"
read -p "Press [Enter] key after this..."

### REQUIRES PASSWORD INPUT
##
## HOMEBREW
##
# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

##
## Git
##

echo "Installing Git..."

brew install git

##
## NVM
##

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

##
## ZSH config
##

## Install MesloLGS NF fonts
## NEEDS password
sudo cp -vf ./fonts/MesloLGS\ NF\ Bold.ttf /Library/Fonts
sudo cp -vf ./fonts/MesloLGS\ NF\ Bold\ Italic.ttf /Library/Fonts
sudo cp -vf ./fonts/MesloLGS\ NF\ Italic.ttf /Library/Fonts
sudo cp -vf ./fonts/MesloLGS\ NF\ Regular.ttf /Library/Fonts

echo "Install MesloLGS NF fonts"
read -p "Press [Enter] to continue..."

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

## copy zshrc
cp .zshrc ~/.zshrc

# M1 needs brew in /opt
echo 'export PATH=/opt/homebrew/bin:$PATH' >> ~/.zshrc

# Install powerline10k theme
echo "Installing Powerline10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
# configure your powerline10k 
p10k configure

echo "p10k is configured, 'p10k configure' to reconfigure"
read -p "Press [Enter] in you want to continue..."

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

### REQUIRES PASSWORD INPUT
echo "Setting ZSH as shell..."
chsh -s /bin/zsh

### REQUIRES PASSWORD INPUT
sudo xcodebuild -license accept

# Git config
echo "Git config"

git config --global user.name $myname
git config --global user.email $email

# Installing other brew packages
echo "Installing packages..."
packages=(
  fzf
)

echo "Installing Apps in /opt/homebrew/Cellar..."

for package in ${packages[@]}
do
    version=$(brew info $package | sed -n "s/$package:\ \(.*\)/\1/p")
    installed=$(find "/opt/homebrew/Cellar/$package" -type d -maxdepth 1 -maxdepth 1 -name "$version")

    if [[ -z $installed ]]; then
        echo "${red}${package}${reset} requires ${red}update${reset}."
        (set -x; brew uninstall $package --force;)
        (set -x; brew install $package --force;)
    else
        echo "${red}${package}${reset} is ${green}up-to-date${reset}."
    fi
done

echo "Cleaning up brew"
brew cleanup

echo "Installing homebrew cask"
brew install homebrew/cask

# Installing cask-versions to get older version of e.g. corretto
brew tap homebrew/cask-versions

# Installing applications with cask
echo "Installing casks..."

# NTH: istat-menus, nordvpn, vlc
casks=(
  1password
  alfred
  camo-studio
  cursor
  google-chrome
  iterm2
  headlamp
  rectangle
  slack
  spotify
)

# Install apps to /Applications
echo "Installing Apps in /opt/homebrew/Caskroom..."

for cask in ${casks[@]}
do
    version=$(brew info $cask | sed -n "s/$cask:\ \(.*\)/\1/p")
    installed=$(find "/opt/homebrew/Caskroom/$cask" -type d -maxdepth 1 -maxdepth 1 -name "$version")

    if [[ -z $installed ]]; then
        echo "${red}${cask}${reset} requires ${red}update${reset}."
        (set -x; brew uninstall $cask --force;)
        (set -x; brew install $cask --force;)
    else
        echo "${red}${cask}${reset} is ${green}up-to-date${reset}."
    fi
done

echo "Done installing Apps!"

##
## VIM CONFIG
##

echo "Setting up vim colors..."
# Setup vim colors, use sonokai
mkdir -p ~/.vim/colors
mkdir -p ~/.vim/autoload/airline/themes/
mkdir -p ~/.vim/autoload/lightline/colorscheme/
curl https://raw.githubusercontent.com/sainnhe/sonokai/master/colors/sonokai.vim >> ~/.vim/colors/sonokai.vim
curl https://raw.githubusercontent.com/sainnhe/sonokai/master/autoload/sonokai.vim >> ~/.vim/autoload/sonokai.vim
curl https://raw.githubusercontent.com/sainnhe/sonokai/master/autoload/airline/themes/sonokai.vim >> ~/.vim/autoload/airline/themes/sonokai.vim
curl https://raw.githubusercontent.com/sainnhe/sonokai/master/autoload/lightline/colorscheme/sonokai.vim >> ~/.vim/autoload/lightline/colorscheme/sonokai.vim

touch ~/.vimrc
echo "\" important!!\nset termguicolors\n\nsyntax enable\n\n\" the configuration options should be placed before `colorscheme sonokai`\n\nlet g:sonokai_style = 'andromeda'\nlet g:sonokai_enable_italic = 1\nlet g:sonokai_disable_italic_comment = 1\n\ncolorscheme sonokai" >> ~/.vimrc

echo "Done with vim colors config!"

echo "Installing npm global packages..."
# NPM
npm install -g n

echo "Done with npm!"

# set screenshot location
mkdir ~/Pictures/Screenshots

defaults write com.apple.iphonesimulator "ScreenShotSaveLocation" -string "~/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "~/Pictures/Screenshots"

# cleanup
echo "Cleaning up the last stuff..."
brew cleanup
rm -f -r /Library/Caches/Homebrew/*
