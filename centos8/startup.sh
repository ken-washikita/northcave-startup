#!/bin/bash

# install packages
dnf -y install dnf-utils python3-inotify || exit 1

# locale
sed -i 's/ja_JP/en_US/' /etc/locale.conf

# PAM
sed -i '/^UsePAM no/s/no/yes/' /etc/ssh/sshd_config

# logrotate
sed -i '/^rotate 4$/s/4/10/' /etc/logrotate.conf

# nftables
sed -i '/inet-filter\.nft/s/^# //' /etc/sysconfig/nftables.conf
systemctl enable nftables
systemctl start nftables

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

# fail2ban nftables
sed -i '/\[sshd\]/a mode = aggressive\
banaction = nftables-multiport\
banaction_allports = nftables-allports' /etc/fail2ban/jail.d/local.conf

# fail2ban blacklist
curl -L https://raw.githubusercontent.com/mitchellkrogza/Fail2Ban-Blacklist-JAIL-for-Repeat-Offenders-with-Perma-Extended-Banning/master/filter.d/blacklist.conf > /etc/fail2ban/filter.d/blacklist.conf
curl -L https://raw.githubusercontent.com/mitchellkrogza/Fail2Ban-Blacklist-JAIL-for-Repeat-Offenders-with-Perma-Extended-Banning/master/action.d/blacklist.conf > /etc/fail2ban/action.d/blacklist.conf
cat <<EOL >>/etc/fail2ban/jail.local

[blacklist]
enabled = true
backend = auto
logpath  = /var/log/fail2ban.*
filter = blacklist
banaction = blacklist
bantime  = 31536000   ; 1 year
findtime = 31536000   ; 1 year
maxretry = 10
EOL
touch /etc/fail2ban/ip.blacklist
systemctl restart fail2ban

# end
