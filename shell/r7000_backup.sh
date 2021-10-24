#!/bin/bash

# Usage:
# ./r7000_backup.sh username:password router_ip

folder="/share/r7000"
target="http://$2/NETGEAR_R7000.cfg"

credentials=$(echo -ne $1 | base64)
date=$(date +"%d-%m-%Y")
dest="${folder}/backup-$date.cfg"

curl $target \
    -H "Authorization: Basic ${credentials}" \
    --output $dest
