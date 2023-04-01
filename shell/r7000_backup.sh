#!/bin/bash

# Backup Netgear R7000 router config via SSH (Fresh Tomato)
# Usage:
# ./r7000_backup.sh username password router_ip

username=$1
password=$2
router_ip=$3

date=$(date +"%d-%m-%Y")
folder="/share/r7000"
file="backup-$date.cfg"

apk add sshpass
sshpass -p $password ssh $username@$router_ip "nvram save $file"
sshpass -p $password scp -O $username@$router_ip:$file $folder
sshpass -p $password ssh $username@$router_ip "rm $file"
