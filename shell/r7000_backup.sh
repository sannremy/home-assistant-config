#!/bin/bash

# Usage:
# ./r7000_backup.sh username:password

folder="/share/r7000"
target="http://routerlogin.com/NETGEAR_R7000.cfg"

credentials=$(echo -ne $1 | base64)
date=$(date +"%d-%m-%Y")
dest="${folder}/backup-$date.cfg"

curl $target \
    -H "Authorization: Basic ${credentials}" \
    --output $dest
