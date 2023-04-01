#!/bin/bash

# Backup Netgear R7000 router config via SSH with authorized keys (Fresh Tomato)
# Usage:
# ./r7000_backup.sh username router_ip

username=$1
router_ip=$2

date=$(date +"%d-%m-%Y")
folder="/share/r7000"
file="backup-$date.cfg"

ssh $username@$router_ip "nvram save $file"
scp $username@$router_ip:$file $folder
ssh $username@$router_ip "rm $file"
