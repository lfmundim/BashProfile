# # # # # # # # # # # # # # # # # # # # # # # # # # # #
#    _             _                     __ _ _       #
#   | |__  __ _ __| |_     _ __ _ _ ___ / _(_) |___   #
#  _| '_ \/ _` (_-< ' \   | '_ \ '_/ _ \  _| | / -_)  #
# (_)_.__/\__,_/__/_||_|__| .__/_| \___/_| |_|_\___|  #
#                     |___|_|                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # #



# Colors
[[ -r "$(dirname "$BASH_SOURCE")/.bash_profile__colors" ]] && source "$(dirname "$BASH_SOURCE")/.bash_profile__colors"



###############
### ALIASES ###
###############

alias psg='ps aux | grep'
alias ll='ls -hal'
alias grep='grep --color'
alias l='ls'
alias cl='curl -L'
alias ..='cd ..'
alias ...='cd ...'
alias sl='ls'
alias c='clear'
alias matrix='LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'
alias lastchanges='find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | cut -f2- -d" "'

alias flush__memcached="echo 'flush_all' | nc localhost 11211"
alias flush__dns="dscacheutil -flushcache"

alias pip='pip3'		            # Preferred pip version
alias python='python3'                      # Preferred python version
jnote() { jupyter notebook $@; }             # Shortcut to Jupyter Notebook
alias gitgud='cd /Volumes/Storage/Git/'      # Shortcut to Git folder on HDD
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address

#alias reset_launchpad="defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock"



###############
### UTILITY ###
###############

# bash_prifile get project path
function bash_profile__path {
    echo $(dirname "$BASH_SOURCE")
}

# bash_profile move to project folder
function bash_profile__cd {
    cd $(bash_profile__path)
}

# bash_profile get version
function bash_profile__version {
    cat ~/bash_profile/VERSION
}

# bash_profile reload the project
function bash_profile__reload {
    source $(bash_profile__path)/.bash_profile
}

# bash_profile reload your own .bash_profile or .bashrc
function bash_profile__reload_all {
    [[ -r "$HOME/.bash_profile" ]] && source ~/.bash_profile
    [[ -r "$HOME/.bashrc" ]] && source ~/.bashrc
}

# bash_profile update
function bash_profile__update {
    message=`git -C $(bash_profile__path) checkout . && git -C $(bash_profile__path) pull -r`
    if [[ $message == *"is up to date"* || $message == *"up-to-date"* ]]; then
        echo;
        echo -e "$COLOR_ALT_CYAN""----------------------"
        echo -e "$COLOR_ALT_CYAN""BASH_PROFILE"
        echo -e "$COLOR_CYAN""no update available"
        echo -e "$COLOR_ALT_CYAN""----------------------"
        echo -e "$COLOR_NORMAL"
    else
        if [[ $message != "" ]]; then
            echo $message > $(bash_profile__path)/UPDATED
        fi
    fi
}

# Utility
[[ -r "$(bash_profile__path)/.bash_profile__utility" ]] && source "$(bash_profile__path)/.bash_profile__utility"



###########
### GIT ###
###########

# compose a useful string containing git information
function gitify {
    echo ""
}

[[ $(cli__is_installed git) == true ]] && source $(bash_profile__path)/.bash_profile__git

# Bash Completions
[[ -r "$(bash_profile__path)/.bash_completion_git" ]] && source $(bash_profile__path)/.bash_completion_git



###########
### SVN ###
###########

# compose a useful string containing svn information
function svnify {
    echo ""
}

[[ $(cli__is_installed svn) == true ]] && source $(bash_profile__path)/.bash_profile__svn

# Bash Completions
[[ -r "$(bash_profile__path)/.bash_completion_svn" ]] && source $(bash_profile__path)/.bash_completion_svn



###########
### SSH ###
###########

# Bash Completions
[[ -r "$(bash_profile__path)/.bash_completion_ssh" ]] && source $(bash_profile__path)/.bash_completion_ssh



###########
### PS1 ###
###########

function __bash_profile__check_updates {
    if [[ -f $(bash_profile__path)/UPDATED ]]; then
        bash_profile__reload
        echo;
        echo -e "$COLOR_ALT_GREEN""---------------------------"
        echo -e "$COLOR_ALT_GREEN""BASH_PROFILE"
        echo -e "$COLOR_GREEN""updated to version $(bash_profile__version)"
        echo -e "$COLOR_ALT_GREEN""---------------------------"
        echo;
        echo -e "$COLOR_GREEN""🗣  What's New - https://goo.gl/EKaOnc"
        echo -e "$COLOR_NORMAL"
        rm $(bash_profile__path)/UPDATED
    fi
}

function __bash_profile__set_prompt {
    PS1="\n\[$COLOR_GREEN\][\w]\[$COLOR_YELLOW\] $(gitify) $(svnify) \n\[$COLOR_CYAN\][\u@\h \$] \[$COLOR_RED\]> \[$COLOR_NORMAL\]"
}

export PROMPT_COMMAND="__bash_profile__check_updates; __bash_profile__set_prompt; $PROMPT_COMMAND"



###############
### EXPORTS ###
###############

export GIT_EDITOR="vim"
export SVN_EDITOR="vim"
export EDITOR="vim"
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad



#####################
### SPLASH SCREEN ###
#####################

function __bash_profile__splash_screen {
    echo;
    echo -e "    _             _                     __ _ _         "
    echo -e "   | |__  __ _ __| |_     _ __ _ _ ___ / _(_) |___     "
    echo -e "  _| '_ \/ _\` (_-\< ' \   | '_ \\ '_/ _ \  _| | / -_) "
    echo -e " (_)_.__/\__,_/__/_||_|__| .__/_| \___/_| |_|_\___|    "
    echo -e "                     |___|_|                           "
    echo -e "                                              "$(bash_profile__version)
    echo;
    echo;
}



###############
### GETOPTS ###
###############

OPTIND=1
while getopts "wup:" OPT; do
    case $OPT in
        w)
            __bash_profile__splash_screen
            ;;
        u)
            (bash_profile__update > /dev/null 2>&1 &)
            ;;
        p)
            proxy__set $OPTARG
            ;;
    esac
done
