#!/bin/bash
LOCAL_INSTALL=0
DEFAULT_DOWNLOAD_DIR="/etc/";
#install block

cd $DEFAULT_DOWNLOAD_DIR;
apt-get install fail2ban

echo -n  "Select Option 1: PVE fail2ban script 2: PBS fail2ban script OR q:Quit :"
read choice

if [ "$choice" == "1" ]; then
echo "you choose PVE script"
cat >/etc/fail2ban/jail.local <<EOL
  [proxmox-web-gui]
  enabled  = true
  port     = http,https,8006
  filter   = proxmox-web-gui
  logpath  = /var/log/daemon.log
  maxretry = 4
  bantime = 240
EOL

cat >/etc/fail2ban/filter.d/proxmox.conf << EOL
[Definition]
failregex = pvedaemon\[.*authentication failure; rhost=<HOST> user=.* msg=.*
ignoreregex =
EOL
#Testing Fail2ban Filters
echo "filter testing ^^";
#test du service
service fail2ban restart
service fail2ban status

echo "thanks fo using this script ^^";

elif [ $choice == "2" ]; then
  echo "you choose PBS script"
  cat >/etc/fail2ban/jail.local <<EOL
    [proxmox-web-gui]
    enabled  = true
    port     = http,https,8007
    filter   = proxmox-web-gui
    logpath  = /var/log/daemon.log
    maxretry = 4
    bantime = 240
EOL

cat >/etc/fail2ban/filter.d/proxmox.conf << EOL
[Definition]
failregex = pvedaemon\[.*authentication failure; rhost=<HOST> user=.* msg=.*
ignoreregex =
EOL
#Testing Fail2ban Filters
echo "filter testing ^^";
#test du service
service fail2ban restart
service fail2ban status

echo "thanks fo using this script ^^";
echo "You can check jail configuration in /etc/fail2ban/jail.local";
else
  echo "bye"
fi
