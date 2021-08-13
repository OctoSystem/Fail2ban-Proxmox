
#!/bin/bash
LOCAL_INSTALL=0
DEFAULT_DOWNLOAD_DIR="/etc/";
#install block

cd $DEFAULT_DOWNLOAD_DIR;
apt-get install fail2ban
cat >/etc/fail2ban/jail.local <<EOL
  [proxmox-web-gui]
  enabled  = true
  port     = http,https,8006
  filter   = proxmox-web-gui
  logpath  = /var/log/daemon.log
  maxretry = 4
  bantime = 240
EOL

#create Fail2ban filters
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
