#!/bin/bash

# install packages
yum -y install wget yum-utils python-inotify || exit 1

# locale
sed -i 's/ja_JP/en_US/' /etc/locale.conf

# PAM
sed -i 's/^UsePAM no/UsePAM yes/' /etc/ssh/sshd_config

# logrotate
sed -i 's/^rotate 4$/rotate 10/' /etc/logrotate.conf

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

# filter slice messages
# https://access.redhat.com/ja/solutions/2601461
cat <<EOL >/etc/rsyslog.d/ignore-systemd-session-slice.conf
if \$programname == "systemd" and (\$msg contains "Starting Session" or \$msg contains "Started Session" or \$msg contains "Created slice" or \$msg contains "Starting user-" or \$msg contains "Starting User Slice of" or \$msg contains "Removed session" or \$msg contains "Removed slice User Slice of" or \$msg contains "Stopping User Slice of") then stop
EOL

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

# end
