#!/bin/bash
<<<<<<< HEAD
#HighVPN RmnJL
json_output="["

port_dropbear=$(ps aux | grep dropbear | awk NR==1 | awk '{print $17;}')
log="/var/log/auth.log"
loginsukses="Password auth succeeded"

pids=$(ps ax | grep dropbear | grep " $port_dropbear" | awk -F" " '{print $1}')

for pid in $pids
do
    pidlogs=$(grep $pid $log | grep "$loginsukses" | awk -F" " '{print $3}')
    i=0
    for pidend in $pidlogs
    do
      let i=i+1
    done
    if [ $pidend ];then
       login=$(grep $pid $log | grep "$pidend" | grep "$loginsukses")
       PID=$pid
       user=$(echo $login | awk -F" " '{print $10}' | sed -r "s/'/ /g")
       user=$(echo $user | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')
       waktu=$(echo $login | awk -F" " '{print $2"-"$1,$3}')
       while [ ${#waktu} -lt 13 ]; do
           waktu=$waktu" "
       done
       while [ ${#user} -lt 16 ]; do
           user=$user" "
       done
       while [ ${#PID} -lt 8 ]; do
           PID=$PID" "
       done
       user=$(echo $user | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//')
       json_item="{"
       json_item+="\"user\": \"$user\", "
       json_item+="\"PID\": \"$PID\", "
       json_item+="\"waktu\": \"$waktu\""
       json_item+="}"
       json_output+=" $json_item,"

    fi
done
json_output="${json_output%,}"
json_output+="]"
echo "$json_output" > /var/www/html/panel/storage/dropbear.json
=======
# HighVPN RmnJL - نسخه بهبود یافته و پایدار
set -euo pipefail

json_output="["

# استخراج پورت‌های فعال dropbear
ports=$(ss -ltnp 2>/dev/null | grep dropbear | awk '{print $4}' | awk -F: '{print $NF}' | sort -u)
log="/var/log/auth.log"
[ -f /var/log/secure ] && log="/var/log/secure"
loginsukses="Password auth succeeded"

for port in $ports; do
    pids=$(pgrep -f "dropbear.*$port")
    for pid in $pids; do
        # استخراج آخرین ورود موفق برای این PID
        login=$(grep "$pid" "$log" | grep "$loginsukses" | tail -n 1)
        if [ -n "$login" ]; then
            user=$(echo "$login" | awk '{print $10}')
            waktu=$(echo "$login" | awk '{print $2 "-" $1, $3}')
            PID="$pid"
            # ساخت JSON ایمن
            json_item="{\"user\": \"$user\", \"PID\": \"$PID\", \"waktu\": \"$waktu\"}"
            json_output+="$json_item,"
        fi
    done
done
json_output="${json_output%,}]"

# اطمینان از وجود دایرکتوری خروجی
outdir="/var/www/html/panel/storage"
mkdir -p "$outdir"
echo "$json_output" > "$outdir/dropbear.json"
>>>>>>> f103409 (Initial stable and improved version upload)
