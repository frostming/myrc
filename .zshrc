
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt no_nomatch
# If you come from bash you might have to change your $PATH.
export GOPATH=$HOME/wkspace/go
export PATH=$HOME/Library/PythonUp/bin:$HOME/Library/PythonUp/cmd:$HOME/wkspace/flutter/bin:$HOME/.local/bin:${GOPATH//://bin:}/bin:$PATH
export PATH=$PATH:/opt/homebrew/bin

# Path to your oh-my-zsh installation.
export ZSH=/Users/fming/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
#eval "$(starship init zsh)"
DEFAULT_USER="fming"
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
plugins=(git brew node pip npm zsh-syntax-highlighting zsh-autosuggestions docker)
fpath+=/opt/homebrew/share/zsh/site-functions
source $ZSH/oh-my-zsh.sh
compinit
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ..="cd .."
alias ...="cd ../.."
alias wk="cd $HOME/wkspace"
alias abrew=/opt/homebrew/bin/brew
export BAT_THEME="Dracula"
alias cat=bat

#PyEnv settings
#export PYENV_ROOT="$HOME/.pyenv"

#eval "$(pyenv init -)"
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

transfer() {
    # check arguments
    if [ $# -eq 0 ];
    then
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$( mktemp -t transferXXX )

    # upload stdin or file
    file=$1

    if tty -s;
    then
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi

        if [ -d $file ];
        then
            # zip directory and transfer
            zipfile=$( mktemp -t transferXXX.zip )
            cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
        fi
    else
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
    fi

    # cat output link
    cat $tmpfile

    # cleanup
    rm -f $tmpfile
}

launchctl setenv LC_ALL zh_CN.UTF-8
eval "$(direnv hook zsh)"

function pyc {
  command find . -name "*.pyc" -exec rm -rf {} \;
}

proxy_port=7890

allproxy() {
  export https_proxy=http://127.0.0.1:$proxy_port http_proxy=http://127.0.0.1:$proxy_port all_proxy=socks5://127.0.0.1:$proxy_port
}

unproxy() {
  unset https_proxy http_proxy all_proxy
}

gt() {
  cd $HOME/wkspace/github/$1
}

_gt() {
  _arguments "1:filename:_files -W $HOME/wkspace/github"
}
compdef _gt gt

n() {
  $HOME/wkspace/logseq/scripts/sync.sh
}

up() {
  abrew update && abrew upgrade && pipx upgrade-all
}

serve() {
  python3 -m http.server "$@"
}

export GPG_TTY=$(tty)
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
#source /usr/local/bin/virtualenvwrapper.sh

export PATH=/opt/homebrew/sbin:$PATH
export PYTHONPATH='/Users/fming/wkspace/github/pdm/src/pdm/pep582':$PYTHONPATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
% function xbin() {
  command="$1"
  args="${@:2}"
  if [ -t 0 ]; then
    curl -X POST "https://xbin.io/${command}" -H "X-Args: ${args}"
  else
    curl --data-binary @- "https://xbin.io/${command}" -H "X-Args: ${args}"
  fi
}

