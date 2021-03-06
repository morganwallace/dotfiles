# #      ___       __       __       ___           _______. _______     _______.
# #     /   \     |  |     |  |     /   \         /       ||   ____|   /       |
# #    /  ^  \    |  |     |  |    /  ^  \       |   (----`|  |__     |   (----`
# #   /  /_\  \   |  |     |  |   /  /_\  \       \   \    |   __|     \   \
# #  /  _____  \  |  `----.|  |  /  _____  \  .----)   |   |  |____.----)   |
# # /__/     \__\ |_______||__| /__/     \__\ |_______/    |_______|_______/
# #  Custom aliases and functions for .dotfiles repo


# ###########
# # Locations
# ###########

export DOTFILESHOME=$HOME/.dotfiles
export MAINALIASES=$DOTFILESHOME/custom/aliases.zsh


# #############
# # Git Aliases
# #############


export GIT_AUTHOR="Morgan"
alias gits="git status"
alias gitundo="git reset --soft HEAD~"
alias delbranch="git branch -D"
alias cleanbranches="git checkout develop && git pull origin develop && git branch --merged | grep -Ev 'develop|core|\*' | xargs git branch -d && git remote prune origin"
alias gitgraph="git log --graph --pretty=oneline --abbrev-commit"
alias mylog="git log --author=$GIT_AUTHOR"
alias mygraph="git log --graph --pretty=oneline --abbrev-commit --author=$GIT_AUTHOR"
alias difflast="git diff HEAD~1"
alias jiracommit="git commit --allow-empty -m"
alias gc="git commit"
alias gcn="git commit --no-verify"
alias gch="git checkout"
alias gchb="git checkout -b "
alias gp="git push"
alias gpo="git push origin"
alias gpl="git pull"
alias gplo="git pull origin"
alias gri="git rebase -i"
alias gchrp="git cherry-pick"
alias gstshu="git stash -u"
alias gcheckoutlaststash='git checkout $(git stash list | grep -P -o "(?<=WIP on )(.*)(?=:)" -m 1)'
alias newbranch="git checkout master && git pull origin master && git checkout -b "
alias lastcommithash="git log -n 1 | head -n 1 | sed -e 's/^commit //'"
alias squash="git commit --squash $(lastcommithash)"
function grih() {
    git rebase -i HEAD~$1
}
alias keepssh="eval '$(ssh-agent -s)' && ssh-add ~/.ssh/id_rsa"

function pr() {
    if [ -z "$(git status --porcelain)" ]; then
        git checkout develop
        git branch -D "pr/$1"
        git fetch -fu origin pull/$1/head:pr/$1
        git checkout pr/$1

        # Check to see if the git checkout was successful
        BRANCH=$(git rev-parse --abbrev-ref HEAD)
        if [[ "$BRANCH" == "pr/$1" ]]; then
            git pull -f origin pull/$1/head:pr/$1
        else
            echo 'Was not able to change branch';
        fi
    else
        echo 'Git not clean. Branch not changed'
    fi
}

function update_rebase () {
    cur_branch=$(git rev-parse --abbrev-ref HEAD)
    git checkout $1
    git pull origin $1
    git checkout $cur_branch
    git rebase -i $1
}

function getbranch() {
    git fetch -fu origin $1:$1
    git checkout $1
}


# ########
# # Python
# ########

alias rmpyc="find . -name '*.pyc' -exec rm -rf {} \;"

# Virtual Environments
alias svba="source ./venv/bin/activate"
alias virt="source ${VENV_BIN}activate"
alias act="virt"

# given a string of python code return the timeit performance
function python_speed () {
    python -m timeit -s "$1"
}

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

##############
# Applications
##############

# Code Editor
alias edit="code"

# Editor for commits and stuff
export EDITOR='vim'


#############
# Ubuntu Specific
#############

alias settime="sudo ntpdate -u pool.ntp.org"
alias lookat="watch -n1 -- "
# NOTE must install xclip: `sudo apt-get install xclip`
alias copy="xclip -selection c"
alias pwdc="pwd | copy"
alias lsusers="cut -d: -f1 /etc/passwd"

alias settime="sudo ntpdate -u pool.ntp.org"
alias lookat="watch -n1 -- "
# NOTE must install xclip: `sudo apt-get install xclip`
alias copy="xclip -selection c"
alias pwdc="pwd | copy"
alias lsusers="cut -d: -f1 /etc/passwd"


#############
# Mac Specific
#############
alias runintel='arch -x86_64'
alias wheresgit='xcode-select --install'

#############
# Zsh aliases
#############
alias settings="edit $HOME/.zshrc"
alias dotfiles="cd $DOTFILESHOME"
alias shortcuts="edit $MAINALIASES"
alias mytheme="edit $DOTFILESHOME/custom/themes/dotfiles.zsh-theme"
alias zshconf="edit $DOTFILES/global_config/.zshrc"

function localalias () {
    touch "~/.private_aliases/$1.zsh"
    ln -s "~/.private_aliases/$1.zsh" aliases.zsh
}

function zshrefresh (){
    source $HOME/.zshrc
}
alias zr="zshrefresh"


# System Aliases
alias search='find . -name'
alias killchromes='killall -i chrome'
alias myip="ifconfig | grep -P '(?<=inet addr:)192\.168\.[0-9]+\.[0-9]+' -o"


# Custom searcher
mg () { grep -Rn "$*" *; }


############
# Node & NPM
############

function vnpm() {
    sudo rm `which npm`
    sudo ln -s /usr/local/n/versions/node/$1/lib/node_modules/npm/cli.js /usr/local/bin/npm
}

# Change node and npm versions before node v4
function chnode() {
    sudo n $1
    sudo vnpm $1
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


########
# Docker
########
function dkr () {
    # Shortcut to run commands in a docker container
    # Usage: dkr <container-name> <command>
    docker exec -it $1 $2
}
function dkrbash () {
    dkr $1 bash
}

########################
# CLI Generated Aliasing
# ######################
function makealias () {
    echo "alias $1='$2'" >> $MAINALIASES
    zshrefresh
}
# *- CLI-made aliases are appended here, at the end of the file: -*
alias dotact='. /Users/morgan/.pyenv/versions/3.8.0/envs/dotfiles_env/bin/activate'
alias actdot="dotact"
alias zrc="code $DOTFILES/global_config/.zshrc"
