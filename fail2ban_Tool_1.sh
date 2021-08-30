#!/bin/bash
LOCAL_INSTALL=0
DEFAULT_DOWNLOAD_DIR="/etc/";
#install block

cd $DEFAULT_DOWNLOAD_DIR;

#
# Install section
#
apt-get install fail2ban
apt-get install ssmtp
apt-get mailutils
#
#       SSMTP
#

#fail2ban sender file
#
touch /tmpfail2ban-mail.txt
chmod 777 /tmpfail2ban-mail.txt
#security
#
chmod 600 /etc/ssmtp/ssmtp.conf
useradd ssmtp -g nogroup -s /sbin/nologin -c "sSMTP pseudo-user"
chown ssmtp /etc/ssmtp/ssmtp.conf
echo "the ssmtp user has been created !"

#mail configuration
#
echo "------------------------"
echo "|    daily mail mod     |"

echo "1- the sendermail configuration"
echo -n "enter the sender mail :"
read sendermail
echo -n "enter the name of sender mail ex:gary :"
read sendername
echo -n "enter the mailhub ex:smtp.gmail.com:587 :"
read mailhub
echo -n "enter the passords sender :"
read authopass
echo -n "enter the recipient"
read recipient
#think TLS Y/N

cat >/etc/ssmtp/ssmtp.conf <<EOL
root=$sendermail            # Your email address
UseSTARTTLS=YES
mailhub=$mailhub           # Address and port number to send mail to
AuthUser=$mailhub   # Your Username
AuthPass=$authopass                       # Your Password
rewriteDomain=                                 # So the message appears to come from FAI
FromLineOverride=YES                    # So the message appears to come from FAI
hostname=$mailhub # Hostname: use hostname -f in a Terminal
EOL

ufw allow out  587/tcp

cat >/etc/ssmtp/revaliases <<EOL
# sSMTP aliases
#
# Format:	local_account:outgoing_address:mailhub
#
# Example: root:your_login@your.domain:mailhub.your.domain[:port]
# where [:port] is an optional port number that defaults to 25.
# Exempla: root:your_identifiant@fournisseur.com:mail.fournisseur.com:587
root:$sendermail:$mailhub
# Other System user: (for Apache)
# www-data:your_identifiant@fournisseur.com:mail.fournisseur.com:587
EOL

cat >/tmp/fail2ban-mail.txt <<EOL
mettre la conf
EOL


#
#     Failt2Ban configuration
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

  [sendermail]
  detemail = $sendermail
  sendername = $sendername
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

    [sendermail]
    detemail = $sendermail
    sendername = $sendername
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
