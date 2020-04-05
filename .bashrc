# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# User specific aliases and functions
export PS1='...\h:\W% '

export HISTCONTROL=ignoredups:erasedups

PATH=$HOME/bin:$PATH
export PATH

alias ls='ls -F'
alias ll='ls -AlF'
alias h='history|tail -20'
#alias psme='ps waux | grep dpoole'
alias lsd='ls -d */'
function psme () { ps -eF | grep ^dpoole; }

findc () { find ${1:-.} -name '*.c'; }
findh () { find ${1:-.} -name '*.h'; }
findf () { find ${1:-.} -type f; }
findS () { find ${1:-.} -name '*.S'; }
findpy () { find ${1:-.} -name '*.py'; }
alias xg="xargs grep"
# find makefiles
findm() { find . -name Makefile -o -name makefile -o -name '*.mk'; }
findjs() { find . -name '*.js'; }
findv() { find . -name '*.v' -o -name '*.sv' -o -name '*.vh' ; }

function lk () { ls -lrt $@ | tail; }

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

export EDITOR=vim
export VISUAL=vim

# davep 28-Jan-2015
hl() { hdump $1 | less; }
hh() { for f in $@ ; do (hdump $f | head) ; done; }
iv() { identify -verbose $@ | less; }

# davep 26-Mar-2015
gs() { git status $@; }
gsu() { git status -uno $@; }
gd() { git diff $@ ; }
gdc() { git diff --cached $@ ; }
gc() { git commit $@; }
m() { make $@; }
gb() { git --no-pager branch $@; }

alias p3=python3

export COCONUT_TOOLCHAIN=/home/dpoole/src/toolchain/64bit_build_bins

s() { cd /home/dpoole/src/coconut/service_manager/services/gps; }
d() { cd /home/dpoole/src/coconut/test/standalone/gps; }
t() { cd /home/dpoole/src/coconut; }
gt() { cd /home/dpoole/src/coconut.garnet; }
ht() { cd /home/dpoole/src/coconut.hulk; }
st() { cd /home/dpoole/src/coconut.spock; }
ct() { cd /home/dpoole/src/coconut.congo; }
ms() { make service_manager; }
mall() { make service_manager lib tools; }

mt7612() { cd kernel_modules/ralink_wireless/wireless_mt7612e/rlt_wifi; }

dts() { cd /home/dpoole/src/coconut.bulk/qcom/linux/arch/arm/boot/dts; }

export xlib=lib/python-cp
export xsms=service_manager/services

cdtest() { pushd test/legacy/standalone/wifi; }

cdtest() { pushd test/legacy/standalone/wifi ; }
cdcoco() { cd ~/src/coconut; }

kk() { eval $(/usr/bin/keychain --eval id_rsa); }

cpcp() { scp coconut.img ad:/var/lib/tftpboot/. ; }

putI() { scp coconut.bin I:tmp/. && ssh I "openssl sha512 ~/tmp/coconut.bin" ; }

# disable tests in servicemanager/Makefile because slow&annoying
fixsmm() { sed -e 's/^all:.*$/all: .all/' -e 's/^default:.*$/default: all/' -i service_manager/Makefile ; } 

