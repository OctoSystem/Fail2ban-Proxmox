
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

#filter testing
fail2ban-regex /var/log/daemon.log /etc/fail2ban/filter.d/proxmox-web-gui.conf
echo "filter testing";
#test du service
service fail2ban restart
fail2ban-client -v status
