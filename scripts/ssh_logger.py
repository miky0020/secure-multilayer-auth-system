#!/usr/bin/env python3
import os, json, datetime

LOG_FILE = "/var/log/ssh_analytics.json"

entry = {
    "timestamp": str(datetime.datetime.now()),
    "user": os.environ.get("PAM_USER", "unknown"),
    "ip": os.environ.get("PAM_RHOST", "unknown"),
    "type": os.environ.get("PAM_TYPE", "unknown"),
    "service": os.environ.get("PAM_SERVICE", "unknown")
}

try:
    with open(LOG_FILE, "a") as f:
        f.write(json.dumps(entry) + "\n")
except Exception as e:
    pass
