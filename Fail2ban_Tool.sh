
#!/bin/bash
# visit www.octosystem.eu ^^
LOCAL_INSTALL=0
DEFAULT_DOWNLOAD_DIR="/etc/";
#install block

cd $DEFAULT_DOWNLOAD_DIR;
apt-get install fail2ban


# Bash Menu Script Example

PS3='Please enter your choice: '
options=("Option 1: basic fail2ban script" "Option 2: PVE fail2ban script" "Option 3: PBS fail2ban script" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
            echo "you chose basic fail2ban"
            cat >/etc/fail2ban/jail.local <<EOF
              [proxmox-web-gui]
              enabled  = true
              port     = http,https,80,443
              filter   = proxmox-web-gui
              logpath  = /var/log/daemon.log
              maxretry = 4
              bantime = 240
            EOF
          break
            ;;
        "Option 2")
            echo "you chose PVE fail2ban script"
                  cat >/etc/fail2ban/jail.local <<EOF
                    [proxmox-web-gui]
                    enabled  = true
                    port     = http,https,8006
                    filter   = proxmox-web-gui
                    logpath  = /var/log/daemon.log
                    maxretry = 4
                    bantime = 240
                  EOF
            break
            ;;
        "Option 3")
            echo "you chose PBS fail2ban script"
                  cat >/etc/fail2ban/jail.local <<EOF
                    [proxmox-web-gui]
                    enabled  = true
                    port     = http,https,8007
                    filter   = proxmox-web-gui
                    logpath  = /var/log/daemon.log
                    maxretry = 4
                    bantime = 240
                  EOF
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

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
