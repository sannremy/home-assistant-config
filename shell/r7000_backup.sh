#!/bin/bash

# Usage:
# ./r7000_backup.sh username:password router_ip

folder="/share/r7000"
hostname=$2

target_cookie="http://${hostname}/"
target_config="http://${hostname}/NETGEAR_R7000.cfg"

credentials=$(echo -ne $1 | base64)
date=$(date +"%d-%m-%Y")
dest="${folder}/backup-$date.cfg"

# Get XSRF token from cookie
curl -s -c cookie.txt $target_cookie > /dev/null
token=$(tail -n1 cookie.txt  | awk '{print $NF}')

# Download R7000 config
curl $target_config \
    -H "Authorization: Basic ${credentials}" \
    -H "Cookie: XSRF_TOKEN=${token}" \
    --output $dest

# Clean up
rm cookie.txt
