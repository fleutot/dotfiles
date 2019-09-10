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
if [ $HOSTNAME == "vinden" ]; then
    # NOTE: 106 does not work in emacs term, it's non-standard. A possible way
    # to solve this is to use revert instead.
    accentcolorbkd='\[\e[106m\]'  # 106: light cyan background
    accentcolorfg='\[\e[96m\]'    # 96: light cyan
    # clockdisp="[\$(date '+%y%m%d %k:%M:%S')]"
    clockdisp="[\$(date '+%k:%M')]"
    if [ $USER == "gauthier" ]; then
	user_host="" # don't print user and host if it's me on my usual machine
    else
	user_host="\u@\h:"
    fi
elif [ $HOSTNAME == "ionian" ]; then
    accentcolorbkd=$txtblubkd
    accentcolorfg=$txtblu
    clockdisp="[\$(date '+%k:%M')]"
    user_host="\u@\h:"
else
    accentcolorbkd=$txtwhtbkd
    accentcolorfg=$txtwht
    clockdisp="[\$(date '+%k:%M')]"
    user_host="\u@\h:"
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

    PS1+="$txtpurrev${VIRTUAL_ENV##*/}$txtrst"

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

    PS1+="$clockdisp$stopped$running$halfblockin$txtrst$txtblk$accentcolorbkd$user_host\w"
    gitstring=$(git_ps1_no_sshfs)

    if [ "$gitstring" == "" ]; then
        PS1+="$halfblockouttodollar"
    else
        PS1+="$halfblockouttogit$gitcolorbkd$gitcolorfg$gitstring$halfblockgittodollar"
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

# enable programmable completion features. This might need to be installed with
# sudo apt-get install bash-completion, at least on Debian.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
    # Add git completion for git aliases (defined elsewhere)
    if [ -f /usr/share/bash-completion/completions/git ]; then
        . /usr/share/bash-completion/completions/git
        __git_complete g __git_main
    else
        echo "No git alias completion available!"
    fi
fi

# Emacs daemon and client management.
# Emacs --daemon must already be running (e.g. started on log in).
# from http://www.emacswiki.org/emacs/EmacsAsDaemon
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c -a emacs"

# Autojump, to change directory fast with history. Autojump itself installed via
# Ubuntu Software Center entry for Bash.
if [[ -x "/usr/bin/autojump" ]]; then
    source /usr/share/autojump/autojump.bash
fi

if [ -f ~/dotfiles/.bash_aliases ]; then
    . ~/dotfiles/.bash_aliases
fi

# Make terminal urgent at the end of a command. Useful after a long command, if the window is not visible.
#export PROMPT_COMMAND='pid-urgent $(ps --no-headers -o ppid | head -1) 2>/dev/null'
# The terminal parent process that is the oldest, hence sort then tail.
#export PROMPT_COMMAND="$PROMPT_COMMAND; pid-urgent \$(ps -o ppid --sort=lstart | tail -1) 2>/dev/null"
#export PROMPT_COMMAND="$PROMPT_COMMAND; pid-urgent \$PPID 2>/dev/null"

# PATH update was somewhere else when I used sobel, but I can't find where. Add here
PATH=~/bin:$PATH
export PATH

# Themes seem to be located at /usr/share/themes
#GTK_THEME=Vertex-Dark
#GTK_THEME=Adwaita:dark
# Install with `sudo apt install arc-theme`
# GTK_THEME=Arc-dark
# GTK_THEME=Blackbird
# Equilux installed with:
#cd /tmp \
#    && wget -O equilux.zip https://github.com/ddnexus/equilux-theme/archive/equilux-dev.zip \
#    && unzip equilux.zip \
#    && equilux-theme-equilux-dev/install.sh \
#    && rm -rf equilux* \
#    && sed -i 's/symbolic/regular/g' /usr/share/themes/Equilux*/gnome-shell/gnome-shell.css
GTK_THEME=Equilux-compact
export GTK_THEME

# GTK2_RC_FILES=/usr/share/themes/Vertex-Dark/gtk-2.0/gtkrc
# GTK2_RC_FILES=/usr/share/themes/Arc-Dark/gtk-2.0/gtkrc
GTK2_RC_FILES=/usr/share/themes/Equilux-compact/gtk-2.0/gtkrc
export GTK2_RC_FILES

# lcam does not run if this is not set. Swedish chars do not work if it is set.
#export LC_ALL=C

# Expand ! expressions (!!, !*, !^, ...) on space.
bind Space:magic-space

### For LumenRadio development
# nRF52
if [ -d "/opt/nrfjprog" ]; then
 export PATH="/opt/nrfjprog:$PATH"
fi
if [ -d "/opt/nrf52-sdk" ]; then
 export NRF52_SDK_ROOT="/opt/nrf52-sdk"
fi
if [ -d "/opt/SEGGER" ]; then
 export NRF52_JLINK_PATH="/opt/SEGGER/"
fi

if [ -d "/opt/gcc-arm-none-eabi-4_9-2015q3/bin" ]; then
 export PATH="/opt/gcc-arm-none-eabi-4_9-2015q3/bin:$PATH"
fi

if [ $HOSTNAME == "vinden" ]; then
    # My nrf52-dk boards, to use with `make flash.$nrf0`
    export nrf0=682641514
    export nrf1=682672792
    #export nrf2=682850131 # This one has disappeared somewhere.
    export nrf2=682496772
    export jlink=268006363
    export nxp=621000000
    export nrf4=683314787 # nrf52840dk
fi

if [ -d "/usr/lib/jvm/java-8-openjdk-amd64/" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
elif [ -d "/usr/lib/jvm/java-8-oracle/" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
fi

# For running cooja via X-forwarding in a non-reparentign WM (xmonad)
if [ -z $DESKTOP_VERSION ]; then
    export _JAVA_AWT_WM_NONREPARENTING=1
fi

# Ignore eof for exiting the terminal
export IGNOREEOF=2

export LD_LIBRARY_PATH="/opt/JLink_Linux_V644h_x86_64:$LD_LIBRARY_PATH"
