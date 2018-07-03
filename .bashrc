# show current git branch + user & path colors
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[$(tput bold)\]\[\033[38;5;32m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;247m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]\\$ \w\[\033[33m\]\$(git_branch)\[\033[00m\]: \[$(tput sgr0)\]"
LS_COLORS=$LS_COLORS:'di=0;32:' ; export LS_COLORS ;

# if you do not want the same coloring i use, simply snag:
#   \w\[\033[33m\]\$(git_branch)\[\033[00m\]
# and add it to your own export PS1 -- remove the leading # from line 10!

# temporary custom nameservers not controlled by network manager (needs to be in root's bashrc)
# pre-requisites: /etc/NetworkManager/NetworkManager.conf must have: dns=none under [main]
#   nameservers obtained from https://opennic.org
#   run: resolv to trigger via cli
#   to make permanent: chattr +i /etc/resolv.conf after disabling symlinking (else will be lost upon next logout/restart)
function resolv(){
  echo "nameserver 162.248.241.94" >> /etc/resolv.conf
  echo "nameserver 172.98.193.42" >> /etc/resolv.conf
  echo "nameserver 128.52.130.209" >> /etc/resolv.conf
  echo "DNS servers have been updated"
}
