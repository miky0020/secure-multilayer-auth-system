#!/bin/bash
BOT_TOKEN="8813643056:AAFok0hbIyJFv3YuokWP2AeeZtX7NaBeAHY"
CHAT_ID="7957260226"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
USER_LOGIN="${PAM_USER}"
REMOTE_IP="${PAM_RHOST}"
TYPE="${PAM_TYPE}"

if [ "$TYPE" = "open_session" ]; then
    MESSAGE="✅ SSH LOGIN SUCCESS%0AUser: ${USER_LOGIN}%0AIP: ${REMOTE_IP}%0ATime: ${DATE}"
elif [ "$TYPE" = "auth" ]; then
    MESSAGE="❌ SSH LOGIN FAILED%0AUser: ${USER_LOGIN}%0AIP: ${REMOTE_IP}%0ATime: ${DATE}"
fi

curl -s "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}&text=${MESSAGE}" > /dev/null
