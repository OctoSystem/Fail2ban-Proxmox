#!/bin/bash

lo
LOCAL_INSTALL=0
DEFAULT_DOWNLOAD_DIR="/etc/";

download_Fail2Ban()
{
cd $DEFAULT_DOWNLOAD_DIR;
if [ $LOCAL_INSTALL == 0 ]; then
   if [ -r $1 ];
      then echo "$1 is already downloaded";
    else apt-get install fail2ban;
    fi;
  fi;
}


modify_jail_local()
  nano /etc/fail2ban/jail.local
  #incrémentéeça
[proxmox-web-gui]
enabled  = true
port     = http,https,8006
filter   = proxmox-web-gui
logpath  = /var/log/daemon.log
maxretry = 4
bantime = 240
{
