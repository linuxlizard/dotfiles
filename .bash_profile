# .bash_profile

if [ -f ~/.bashrc ] ; then
    . ~/.bashrc
fi

eval $(/usr/bin/keychain --eval id_rsa)
