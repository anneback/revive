# #!/bin/sh
# Color variables for output
red='\033[0;31m'
green='\033[0;32m'
reset='\033[0m'

myname="Your name"
email="your.name@email.com"

# Check if SSH key already exists
if [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
  echo "${green}SSH key already exists, skipping...${reset}"
else
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
fi

### REQUIRES PASSWORD INPUT

##
## HOMEBREW
##
# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  echo >> ~/.zshrc
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

##
## NVM
##

# Check if nvm is already installed
if [[ -d "$HOME/.nvm" ]] || command -v nvm &> /dev/null; then
  echo "${green}nvm is already installed, skipping...${reset}"
else
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  
  source ~/.nvm/nvm.sh
  
  nvm install --lts
fi

##
## ZSH config
##

## Install MesloLGS NF fonts
## NEEDS password
if [[ -f "/Library/Fonts/MesloLGS NF Regular.ttf" ]]; then
  echo "${green}MesloLGS NF fonts are already installed, skipping...${reset}"
else
  echo "Installing MesloLGS NF fonts..."
  sudo cp -vf ./fonts/MesloLGS\ NF\ Bold.ttf /Library/Fonts
  sudo cp -vf ./fonts/MesloLGS\ NF\ Bold\ Italic.ttf /Library/Fonts
  sudo cp -vf ./fonts/MesloLGS\ NF\ Italic.ttf /Library/Fonts
  sudo cp -vf ./fonts/MesloLGS\ NF\ Regular.ttf /Library/Fonts
  
  echo "MesloLGS NF fonts installed successfully!"
  read -p "Press [Enter] to continue..."
fi

#Install Zsh & Oh My Zsh
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "${green}Oh My Zsh already exists, skipping...${reset}"
else
  echo "Installing Oh My ZSH..."
  curl -L http://install.ohmyz.sh | sh
fi

## copy zshrc
if [[ -f "$HOME/.zshrc" ]]; then
  echo "${green}Zshrc already exists, skipping...${reset}"
else
  echo "Copying zshrc..."
  cp .zshrc ~/.zshrc
fi

# Install powerline10k theme
if [[ -d "$HOME/powerlevel10k" ]]; then
  echo "${green}Powerline10k already exists, skipping...${reset}"
else
echo "Installing Powerline10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
read -p "Press [Enter] in you want to continue..."
fi

if [[ -d "/opt/homebrew/Cellar/zsh-syntax-highlighting" ]]; then
  echo "${green}Zsh-syntax-highlighting already exists, skipping...${reset}"
else 
  echo "Installing zsh-syntax-highlighting..."
  brew install zsh-syntax-highlighting
fi

### REQUIRES PASSWORD INPUT
# Check if default shell is already zsh
if [[ "$SHELL" == "/bin/zsh" ]]; then
  echo "${green}ZSH is already the default shell, skipping...${reset}"
else
  echo "Setting ZSH as shell..."
  chsh -s /bin/zsh
fi

# Installing other brew packages
echo "Installing packages..."
packages=(
  fzf
)

echo "Installing Apps in /opt/homebrew/Cellar..."

for package in ${packages[@]}
do
    # Check if package directory exists (i.e., package is already installed)
    if [[ -d "/opt/homebrew/Cellar/$package" ]]; then
        echo "${green}${package}${reset} is already installed, skipping..."
    else
        echo "Installing ${red}${package}${reset}..."
        (set -x; brew install $package --force;)
    fi
done

if [[ -d "/opt/homebrew/Cellar/fzf" ]]; then
  echo "${green}Fzf already exists, skipping...${reset}"
else
  echo "Installing fzf into shell"
  source <(fzf --zsh)
fi

echo "Cleaning up brew"
brew cleanup

echo "Installing homebrew cask"
brew install cask

# Installing applications with cask
echo "Installing casks..."

# NTH: headlamp, cursor, istat-menus, nordvpn, vlc
casks=(
  alfred
  camo-studio
  iterm2
  rectangle
  slack
  spotify
)

# Install apps to /Applications
echo "Installing Apps in /opt/homebrew/Caskroom..."

for cask in ${casks[@]}
do
    # Check if cask directory exists (i.e., cask is already installed)
    if [[ -d "/opt/homebrew/Caskroom/$cask" ]]; then
        echo "${green}${cask}${reset} is already installed, skipping..."
    else
        echo "Installing ${red}${cask}${reset}..."
        (set -x; brew install $cask --force;)
    fi
done

echo "Done installing Apps!"

##
## VIM CONFIG
##
if [[ -f "$HOME/.vimrc" ]]; then
  echo "${green}Vimrc already exists, skipping...${reset}"
else
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
  echo "\" important!!\nset termguicolors\n\nsyntax enable\n\n\" the configuration options should be placed before 'colorscheme sonokai'\n\nlet g:sonokai_style = 'andromeda'\nlet g:sonokai_enable_italic = 1\nlet g:sonokai_disable_italic_comment = 1\n\ncolorscheme sonokai" >> ~/.vimrc
fi

echo "${green}Done with vim colors config!${reset}"

echo "Installing npm global packages..."
# NPM
npm install -g n

echo "${green}Done with npm!${reset}"

# set screenshot location
if [[ -d "$HOME/Pictures/Screenshots" ]]; then
  echo "${green}Screenshots directory already exists, skipping...${reset}"
else
  echo "Creating Screenshots directory..."
  mkdir ~/Pictures/Screenshots
  defaults write com.apple.iphonesimulator "ScreenShotSaveLocation" -string "~/Pictures/Screenshots"
  defaults write com.apple.screencapture location -string "~/Pictures/Screenshots"
fi

# cleanup
echo "Cleaning up the last stuff..."
brew cleanup
rm -f -r /Library/Caches/Homebrew/*

echo "${green}DONE WITH INSTALLATION!${reset}"
