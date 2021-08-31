#!/bin/bash

# message first command argument
MESSAGE=$1
HOOK_URL= $slack_token
HOST=$(hostname)

CHANNEL="#alerts"
USERNAME="fail2ban"
ICON=":cop:"

# ip second command argument
IP=$2
# lets find out from what country we have our hacker
COUNTRY=$(curl ipinfo.io/${IP}/country)
# converting country to lover case. I love you bash script =\
COUNTRY=$(echo "$COUNTRY" | tr -s  '[:upper:]'  '[:lower:]')
# slack emoji
COUNTRY=":flag-$COUNTRY:"

# replace _country_ template to the country emoji
MESSAGE="${MESSAGE/_country_/$COUNTRY}"

curl -X POST --data-urlencode "payload={\"channel\": \"${CHANNEL}\", \"username\": \"${USERNAME}\", \"text\": \"[${HOST}] ${MESSAGE}\", \"icon_emoji\": \"${ICON}\"}" ${HOOK_URL}

exit 0
