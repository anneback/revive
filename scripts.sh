## Useful bash scripts to put in .zshrc
### ALIASES ###
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# remove duplicate resolutions in yarn.lock file
alias dedupe='yarn --force && yarn-deduplicate yarn.lock && yarn'

# dnsflush
alias dnsflush='sudo killall -HUP mDNSResponder;sleep 2;'

### FUNCTIONS ###
# list installed java versions
function jlist() {
   /usr/libexec/java_home -V
}

# change java version
function jversion() {
  if [ $# -ne 0 ]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v $1)
    export PATH=$JAVA_HOME/bin:$PATH
  fi
  echo "-= YOUR JAVA VERSION IS NOW =-"
  java -version
}

# get pid on port
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