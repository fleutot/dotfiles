# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Color definitions
txtblk='\[\e[30m\]' # Black - Regular
txtred='\[\e[31m\]' # Red
txtgrn='\[\e[32m\]' # Green
txtylw='\[\e[33m\]' # Yellow
txtblu='\[\e[34m\]' # Blue
txtpur='\[\e[35m\]' # Purple
txtcyn='\[\e[36m\]' # Cyan
txtwht='\[\e[37m\]' # White
txtdef='\[\e[38m\]' # Default
txtbld='\[\e[1m\]'   # Generic bold
txtblkbld='\[\e[1;30m\]' # Black - Bold
txtredbld='\[\e[1;31m\]' # Red
txtgrnbld='\[\e[1;32m\]' # Green
txtylwbld='\[\e[1;33m\]' # Yellow
txtblubld='\[\e[1;34m\]' # Blue
txtpurbld='\[\e[1;35m\]' # Purple
txtcynbld='\[\e[1;36m\]' # Cyan
txtwhtbld='\[\e[1;37m\]' # White
txtblkund='\[\e[4;30m\]' # Black - Underlined
txtredund='\[\e[4;31m\]' # Red
txtgrnund='\[\e[4;32m\]' # Green
txtylwund='\[\e[4;33m\]' # Yellow
txtbluund='\[\e[4;34m\]' # Blue
txtpurund='\[\e[4;35m\]' # Purple
txtcynund='\[\e[4;36m\]' # Cyan
txtwhtund='\[\e[4;37m\]' # White
txtblkrev='\[\e[7;30m\]' # Black - Reverse
txtredrev='\[\e[7;31m\]' # Red
txtgrnrev='\[\e[7;32m\]' # Green
txtylwrev='\[\e[7;33m\]' # Yellow
txtblurev='\[\e[7;34m\]' # Blue
txtpurrev='\[\e[7;35m\]' # Purple
txtcynrev='\[\e[7;36m\]' # Cyan
txtwhtrev='\[\e[7;37m\]' # White
txtblkbkd='\[\e[40m\]' # Black - background
txtredbkd='\[\e[41m\]' # Red
txtgrnbkd='\[\e[42m\]' # Green
txtylwbkd='\[\e[43m\]' # Yellow
txtblubkd='\[\e[44m\]' # Blue
txtpurbkd='\[\e[45m\]' # Purple
txtcynbkd='\[\e[46m\]' # Cyan
txtwhtbkd='\[\e[47m\]' # White

txtrst='\[\e[m\]'     # reset to standard
txtdim='\[\e[2m\]'    # dim

CLREOL='\[\e[K\]'
SAVECURSOR='\[\es\]'
RESTORECURSOR='\[\eu\]'
MVTO80='\[\e[;80H\]'

#promptbkgd='\[\e[48;5;237m\]'
#promptbkgd='\[\e[48;5;239m\]'
unset promptbkgd

# Different accent color if the current host is not my usual machine.
if [ $HOSTNAME == "gauss" ]; then
    accentcolorbkd=$txtwhtbkd
    accentcolorfg=$txtwht
    # clockdisp="[\$(date '+%y%m%d %k:%M:%S')]"
    clockdisp="[\$(date '+%k:%M')]"
    user="\u"
elif [ $HOSTNAME == "ionian" ]; then
    accentcolorbkd=$txtwhtbkd
    accentcolorfg=$txtwht
    clockdisp="[\$(date '+%k:%M')]"
    user="\u"
else
    accentcolorbkd='\[\e[106m\]'  # 106: light cyan background
    accentcolorfg='\[\e[96m\]'    # 96: light cyan
    clockdisp="[\$(date '+%k:%M')]"
    user="\u"
fi

gitcolorbkd=$txtylwbkd
gitcolorfg=$txtblk
# These are going to be redefined in the prompt command if the separator character is defined
halfblockin=$txtrst$accentcolorbkd" "
halfblockouttodollar=$txtrst$accentcolorbkd" "
halfblockouttogit=$txtrst$accentcolorbkd" "
halfblockgittodollar=$txtrst$accentcolorbkd""

function __prompt_command() {
    local EXIT="$?"
    PS1="${debian_chroot:+($debian_chroot)}$promptbkgd"
    arrow=$'\u25b6'

    if [ $EXIT != 0 ]; then
        PS1+="$txtredrev"
        resultcolorfg=$txtred
    else
        PS1+="$txtcynrev"
        resultcolorfg=$txtcyn
    fi

    if  jobs | grep -i Running > /dev/null ; then
        # Use background color because we are still in reverse
        running="${accentcolorbkd}%"
    else
        running=""
    fi

    if jobs | grep -i Stopped > /dev/null ; then
        # Use background color because we are still in reverse
        stopped="${accentcolorbkd}z"
    else
        stopped=""
    fi

    # Separator char. Needs support for UTF-8
    if [[ $LC_ALL != "C" ]]; then
        halfblockin=$txtrst$accentcolorbkd$resultcolorfg$'\u258b'
        halfblockouttodollar=$txtrst$accentcolorbkd$resultcolorfg$'\u2590'
        halfblockouttogit=$txtrst$accentcolorfg$gitcolorbkd$'\u258b'
        halfblockgittodollar=$txtrst$resultcolorfg$gitcolorbkd$'\u2590'
    fi

    PS1+="$clockdisp$stopped$running$halfblockin$txtrst$txtblk$accentcolorbkd$user@\h:\w"
    gitstring=$(git_ps1_no_sshfs)

    if [ "$gitstring" == "" ]; then
        PS1+="$halfblockouttodollar"
    else
        PS1+="$halfblockouttogit$gitcolorbkd$gitcolorfg$(git_ps1_no_sshfs)$halfblockgittodollar"
    fi

    if [ $EXIT != 0 ]; then
        PS1+="$txtrst$txtredrev$EXIT!"
    fi

    PS1+="$txtrst$txtcynrev\$$txtrst "

}

if [ "$color_prompt" = yes ]; then
    export GIT_PS1_SHOWCOLORHINTS=1
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUPSTREAM="auto"
    export PROMPT_COMMAND=__prompt_command
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS2="&gt"
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -lFh'
alias la='ls -A'
alias lla='ll -a'
alias l='ls -CF'

alias cdh='cd /opt/gauthier' # for local disk home
alias g='git'

ack() {
    # pass default options, pager
    # --no-init prevents clearing the screen at exit
    /usr/bin/ack --color --group "$@" | less --quit-if-one-screen --RAW-CONTROL-CHARS --no-init
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Emacs daemon and client management.
# Emacs --daemon must already be running (e.g. started on log in).
# from http://www.emacswiki.org/emacs/EmacsAsDaemon
alias e='emacsclient -c -a ""'
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c -a emacs"

# Autojump, to change directory fast with history. Autojump itself installed via
# Ubuntu Software Center entry for Bash.
if [[ -x "/usr/bin/autojump" ]]; then
    source /usr/share/autojump/autojump.bash
fi

# gnome-open, in order to use the default application to open a file.
# For example to open a doc with the default editor: $ go my_doc.doc
alias go=gnome-open

# other aliases
alias pag='ps aux | grep'
alias gitroot='cd $(git rev-parse --show-cdup)'

# Make terminal urgent at the end of a command. Useful after a long command, if the window is not visible.
#export PROMPT_COMMAND='pid-urgent $(ps --no-headers -o ppid | head -1) 2>/dev/null'
# The terminal parent process that is the oldest, hence sort then tail.
#export PROMPT_COMMAND="$PROMPT_COMMAND; pid-urgent \$(ps -o ppid --sort=lstart | tail -1) 2>/dev/null"
#export PROMPT_COMMAND="$PROMPT_COMMAND; pid-urgent \$PPID 2>/dev/null"

# PATH update was somewhere else when I used sobel, but I can't find where. Add here
PATH=~/bin:$PATH
PATH=~/.cabal/bin:$PATH
export PATH

GTK_THEME=Vertex-Dark
export GTK_THEME
GTK2_RC_FILES=/usr/share/themes/Vertex-Dark/gtk-2.0/gtkrc
export GTK2_RC_FILES

# lcam does not run if this is not set. Swedish chars do not work if it is set.
#export LC_ALL=C

# Expand ! expressions (!!, !*, !^, ...) on space.
bind Space:magic-space
