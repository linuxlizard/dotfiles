# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export PS1='...\h:\W% '

export HISTCONTROL=ignoredups:erasedups

PATH=$HOME/bin:$PATH
PATH=$PATH:/opt/armgcc/bin
export PATH

alias ls='ls -F'
alias ll='ls -AlF'
alias h='history|tail -20'
alias psme='ps waux | grep davep'
alias lsd='ls -d */'

findc () { find ${1:-.} -name '*.c'; }
findh () { find ${1:-.} -name '*.h'; }
findf () { find ${1:-.} -type f; }
findS () { find ${1:-.} -name '*.S'; }
# find makefiles
findm() { find . -name Makefile -o -name makefile -o -name '*.mk'; }
alias xg="xargs grep"

function lk () { ls -lrt $@ | tail; }

# for Perforce
export P4PORT=10.71.120.88:1666
#export P4PORT=prp4.marvell.com:1666
export P4USER=dpoole
export P4CLIENT=davep_latches_jssl
export P4EDITOR=vim
alias pout="p4 opened"
alias ppend="p4 changes -u dpoole -s pending"
pdiff () 
{ 
    if [ "$1" == "-f" ]; then
        p4 diff -duwbl -f $(rp $2);
    else
        p4 diff -duwbl $(rp $1);
    fi
}

alias smbc='smbclient -A ~/.auth'

alias sizeof='stat -c '\''%s'\'''

function upfoo () 
{ 
    export FOO=$(( ${FOO} + 1 ))
}

# stfu
export LESS=-q
export LESSHISTFILE=/dev/null

# stfu, part 2
unset PROMPT_COMMAND

alias xo="xclip -o"

# davep 28-Jan-2015
hl() { hdump $1 | less; }
hh() { hdump $1 | head ; }
iv() { identify -verbose $@ | less; }

