#!/usr/bin/env bash
# script to update the hosts file
# Must be run as root

# Copy from Teddysun
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
[[ $EUID -ne 0 ]] && echo -e "${red}Error:${plain} This script must be run as root!" && exit 1


DATE=`date`

# backup orignal hosts at first time
if [ ! -f "/etc/hosts.origin" ]; then
  cp /etc/hosts /etc/hosts.origin
fi

# backup prev hosts file
if [ -f "update_hosts.log" ]; then
  cp /etc/hosts "backup/hosts.bak+$DATE"
fi

# clear hosts 
echo "" > /etc/hosts

# for google, wiki, etc.
if [ ! -d "gfwfuck" ]; then
  cd gfwfuck
  git pull
  cd ..
else
  git clone https://github.com/racaljk/hosts gfwfuck
fi

# append gfwfuck host to hosts
cat gfwfuck/hosts >> /etc/hosts

# append dev hosts to hosts
if [ -f "dev.hosts" ]; then
  cat dev.hosts >> /etc/hosts
fi

service dnsmasq restart
echo "updated at "$DATE >> update_hosts.log