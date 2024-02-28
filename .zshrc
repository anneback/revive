########################## ZSH THEME ##########################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme name
ZSH_THEME="robbyrussell"

# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

########################## BREW ##########################
export PATH=/opt/homebrew/bin:$PATH

########################## JAVA ##########################
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="$JAVA_HOME/bin:$PATH"

function jversion () {
  export JAVA_HOME=`/usr/libexec/java_home -v $@`
  echo "JAVA_HOME:" $JAVA_HOME
  echo "java -version:"
  java -version
}

########################## ANDROID ##########################
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator

export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin

########################## PYENV ##########################
export PYENV_ROOT=$HOME/.pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

########################## RUBY ##########################
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

#PATH for rbenv
export PATH="$HOME/.rbenv/shims:$PATH"

########################## NVM ##########################
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# NVMRC - sets node version to .nvmrc file
autoload -U add-zsh-hook
load-nvmrc() {
local node_version="$(nvm version)"
local nvmrc_path="$(nvm_find_nvmrc)"

if [ -n "$nvmrc_path" ]; then
  local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

  if [ "$nvmrc_node_version" = "N/A" ]; then
    nvm install
  elif [ "$nvmrc_node_version" != "$node_version" ]; then
    nvm use
  fi
elif [ "$node_version" != "$(nvm version default)" ]; then
  echo "Reverting to nvm default version"
  nvm use default
fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

########################## ALIASES ##########################
function killport() { lsof -i TCP:$1 | grep LISTEN | awk '{print $2}' | xargs kill -9 }

function jversion () {
  export JAVA_HOME=$(/usr/libexec/java_home -v $@)
  export PATH=$JAVA_HOME/bin:$PATH
  echo ">>>NEW JAVA_HOME:" $JAVA_HOME "<<<"
  echo ">>>NEW java -version:"
  java -version
  echo "<<<<"
}

function javalist () {
  echo "--== Versions available ==--"
  /usr/libexec/java_home -V
}

function brewv()
{
	packs=$(brew list --versions -1)
	casks=$(brew cask list --versions -1)
	echo "::Packages::"
	echo "$packs\n"
	echo "::Casks::"
	echo $casks
}

########################## FINAL STUFF ##########################

# zsh-syntax-highlighting
source /Users/anneback001/dev/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/Users/jesann/.bun/_bun" ] && source "/Users/jesann/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"