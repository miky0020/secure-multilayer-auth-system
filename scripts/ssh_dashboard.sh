#!/bin/bash
LOG="/var/log/ssh_analytics.json"
echo "================================"
echo "     SSH Analytics Dashboard    "
echo "================================"
echo "Total events:      $(wc -l < $LOG)"
echo "Successful logins: $(grep -c 'open_session' $LOG)"
echo "Failed attempts:   $(grep -c 'auth' $LOG)"
echo "--------------------------------"
echo "--- Last 10 Events ---"
tail -10 $LOG | python3 -c "
import sys, json
for line in sys.stdin:
    try:
        e = json.loads(line)
        print(f\"{e['timestamp']} | {e['type']:15} | {e['user']:10} | {e['ip']}\")
    except: pass
"
echo "--------------------------------"
echo "--- Top IPs ---"
grep -o '"ip": "[^"]*"' $LOG | sort | uniq -c | sort -rn | head -5
echo "================================"
