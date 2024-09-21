#!/bin/bash

# install packages
dnf -y install python3-inotify vim-enhanced

# PAM
echo 'UsePam yes' >>/etc/ssh/sshd_config

# logrotate
sed -i '/^rotate 4$/s/4/10/' /etc/logrotate.conf

# vi
cat <<EOL >/root/.vimrc
set compatible
syntax off
set ai
map g 1G
map q :e#
set cpo-=%
set notitle
set tabstop=4
set shiftwidth=4
set encoding=utf-8
set fileencodings=utf-8,euc-jp,sjis,cp932
set ambiwidth=double
set history=50
set more
EOL
sed -i '/^map q/s/$/\r/' /root/.vimrc
ln -s /root/.vimrc /root/.virc

# end
