#!/bin/sh
myname="Your name"
email="your.name@email.com"
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

##
## ZSH config
##

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

# Install powerline10k theme
echo "Installing Powerline10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
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

# Git config
echo "Git config"

git config --global user.name $myname
git config --global user.email $email

# Installing other brew packages
echo "Installing packages..."
brew install fzf
brew install intellij-idea
brew install java
brew install jetbrains-toolbox
brew install node
brew install slack
brew install sublime-text
brew install typescript
brew install yarn
brew install zsh
brew install zsh-syntax-highlighting

echo "Cleaning up brew"
brew cleanup

echo "Installing homebrew cask"
brew install homebrew/cask

# Installing cask-versions to get older version of e.g. corretto
brew tap homebrew/cask-versions

# Installing applications with cask
echo "Installing casks..."
casks=(
  aerial
  alfred
  camo-studio
  corretto
  corretto15
  corretto11
  corretto8
  diffmerge
  firefox
  gimp
  iterm2
  lastpass
  slack
  spectacle
  spotify
  visual-studio-code
)

# Install apps to /Applications
echo "Installing Apps in /usr/local/Caskroom..."

for cask in ${casks[@]}
do
    version=$(brew info $cask | sed -n "s/$cask:\ \(.*\)/\1/p")
    installed=$(find "/usr/local/Caskroom/$cask" -type d -maxdepth 1 -maxdepth 1 -name "$version")

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
curl https://raw.githubusercontent.com/sainnhe/sonokai/master/autoload/airline/themes/sonokai.vim >> ~/.vim/autoload/airline/themes/sonokai.vim
curl https://raw.githubusercontent.com/sainnhe/sonokai/master/autoload/lightline/colorscheme/sonokai.vim >> ~/.vim/autoload/lightline/colorscheme/sonokai.vim

touch ~/.vimrc
echo "\" important!!\nset termguicolors\n\nsyntax enable\n\n\" the configuration options should be placed before `colorscheme sonokai`\n\nlet g:sonokai_style = 'andromeda'\nlet g:sonokai_enable_italic = 1\nlet g:sonokai_disable_italic_comment = 1\n\ncolorscheme sonokai" >> ~/.vimrc

echo "Done with vim colors config!"

# adds start script for zsh-syntax-highlighting
echo "# start zsh-syntax-highlighting\nsource /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

echo "Installing yarn global packages..."
# Yarn
yarn global add yarn-deduplicate

echo "Done with yarn!"

echo "Installing npm global packages..."
# NPM
npm install -g n

echo "Done with npm!"

# cleanup
echo "Cleaning up the last stuff..."
brew cleanup
rm -f -r /Library/Caches/Homebrew/*
