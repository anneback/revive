# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#Path to your oh-my-zsh installation.
export ZSH=/Users/jesann/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="powerlevel9k/powerlevel9k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias links='ll node_modules | grep '\''>'\'

alias dedupe='yarn --force && yarn-deduplicate yarn.lock && yarn'

# dnsflush
alias dnsflush='sudo killall -HUP mDNSResponder;sleep 2;'

# lists versions of brew packages and lists all version if no input is given
function brewv() {
  packs=$(brew list --version -1)
  casks=$(brew cask list --version -1)

  echo "::PACKAGES::"
  echo "$packs\n"
  echo "::CASKS::"
  echo "$casks"
}

# removes branches locally which is merge or removed
function prunegit() {
  git fetch --all --prune && git checkout master && git branch --merged | grep -v master | xargs git branch -d
}

export PATH="/usr/local/sbin:$PATH"

# list installed java versions
function jlist() {
  echo "-= DETECTED VERSIONS =-"
  /usr/libexec/java_home -V
}

# Storybook render only subfolder
story(){
STORYBOOK_DIRECTORY="$1" yarn dev;
}

# change java version
function jversion() {
  jlist
  echo "\n"
  if [ $# -ne 0 ]; then
    unset JAVA_HOME
    export JAVA_HOME=$(/usr/libexec/java_home -v $1)
    export PATH=$JAVA_HOME/bin:$PATH
  fi
  echo "-= YOUR JAVA VERSION IS NOW =-"
  java -version

  echo "To select version: jversion <detected version> e.g. 'jversion 1.8' or 'jversion 11'"
}

# Yalc build and publish
yalci(){
  cd ../../;
  yarn build && cd - && yalc publish;
}

# get pid
function pidport() {
    get_pid=$(lsof -t -i :$1)
    echo "Your process id (pid) on port $1 is: $get_pid"
}

# kill process on port
function killport() {
    read "REPLY?Kill process on port $1? [y/N]: "
    if [[ $REPLY =~ ^[Yy]$ ]]
    then 
       kill -9 $(lsof -t -i :$1)
       echo "-=! KILLED PROCCESS ON PORT [[$1]] !=-"
    fi
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/usr/local/opt/erlang@21/bin:$PATH"

## zsh-syntax-highlighting must be last
source /Users/jesann/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
