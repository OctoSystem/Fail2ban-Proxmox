#!/bin/bash
LOCAL_INSTALL=0
DEFAULT_DOWNLOAD_DIR="/etc/";
#install block

cd $DEFAULT_DOWNLOAD_DIR;

#
# Install section
#
apt-get install fail2ban
#
echo "Slack configuration"
#
#     Slack bot
#
echo -n "enter the sender slack Hook_url :"
read slack_token


cat > /etc/fail2ban/action.d/slack-notify.conf <<EOL
norestored = 1
actionstart = curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"[<host_name>] Fail2Ban (<name>) jail has started\"}" <slack_webhook_url>
actionstop = curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"[<host_name>] Fail2Ban (<name>) jail has stopped\"}" <slack_webhook_url>
actioncheck =
actionban = curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"[<host_name>] Fail2Ban (<name>) banned IP *<ip>* :flag-<country_name>: (<country_name>) \"}" <slack_webhook_url>
actionunban = curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"[<host_name>] Fail2Ban (<name>) unbanned IP *<ip>* :flag-<country_name>: (<country_name>) \"}" <slack_webhook_url>

[Init]
init = 'Sending notification to Slack'
slack_webhook_url = $slack_token
host_name = $(hostname)
country_name = $(curl ipinfo.io/<ip>/country)

EOL

cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

cat > /etc/fail2ban/jail.local <<EOL
  action = %(action_mwl)s
          slack-notify
EOL


  echo "slack bot is up ! "

#
#     Fail2Ban configuration
#
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
service fail2ban start
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
      bantime = 24
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

echo "testing" | mail -s "test" $recipient
echo "testing mail send"
