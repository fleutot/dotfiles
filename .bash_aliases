# gnome-open, in order to use the default application to open a file.
# For example to open a doc with the default editor: $ go my_doc.doc
alias go=gnome-open

# other aliases
alias pag='ps aux | grep'
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias gitrootup='cd .. && gitroot'
alias gr='gitroot'
alias gr..='gitrootup'
alias xo='xdg-open'
alias fn='find -iname'
alias fd='find -type d -iname'

alias e='emacsclient -c -a ""'

# some more ls aliases
alias ll='ls -lFhA'
alias la='ls -A'
alias lla='ll -a'
alias l='ls -CF'

alias cdh='cd /opt/gauthier' # for local disk home
alias g='git'
alias gg='git g -10'
alias gb='git branch'
alias gd='git diff --no-ext-diff' # Explicit `git diff` might call to external diff

ag() {
    if [ -t 1 ]; then
        # pass default options, pager
	/usr/bin/env ag --ignore-dir vendor/contiki --ignore-dir build --color --group "$@" | less --quit-if-one-screen --RAW-CONTROL-CHARS --no-init
    else
	/usr/bin/env ag $*
    fi
}

# Is this really needed??
fzf() {
    ~/bin/fzf $*
}

fzf_cd() {
    find -type d -maxdepth 1 | fzf | cd
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

# cd-like functions, but relative to git root.
function cm()
{
    local cm_topp=$(git rev-parse --show-toplevel 2>/dev/null || echo ~/code/mira)
    cd "$cm_topp/$1"
}
# for cm bash completion
function _cm()
{
    local cm_topp=$(git rev-parse --show-toplevel 2>/dev/null || echo ~/code/mira)
    pushd "$cm_topp" > /dev/null
    _cd $*
    popd > /dev/null
}
complete -o nospace -F _cm cm

# cd activates virtualenv if is exists
function cd() {
    builtin cd "$@"

    if [ $(dirname "$VIRTUAL_ENV") == $(pwd) ] ; then
	# Already at the active virtual env
	return
    fi

    if [[ -d ./venv ]] ; then
	if type deactivate > /dev/null 2>&1 ; then
	    printf "Deactivating virtualenv %s\n" "$VIRTUAL_ENV"
	    deactivate
	fi

	source ./venv/bin/activate
	printf "Setting up   virtualenv %s\n" "$VIRTUAL_ENV"
    fi
}
