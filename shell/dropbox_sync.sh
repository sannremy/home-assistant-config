#!/bin/bash

# Pre-requisites:
#   1. Execute dropbox_uploader.sh in order to generate the config file
#   2. Copy the config file to the home directory AS /config/shell/.dropbox_uploader

# Usage:
# ./dropbox_sync.sh local_backup_folder remote_backup_folder keep_last

config_file="/config/shell/.dropbox_uploader"
local_backup_folder=$1
remote_backup_folder=$2
keep_last=$3

# Download dropbox_uploader.sh and make it executable
curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
chmod +x dropbox_uploader.sh

# Compare files in dropbox and local folder
remote_list=$(./dropbox_uploader.sh -f $config_file list $remote_backup_folder)
local_list=($(ls -1 -t $local_backup_folder | head -n $keep_last))

echo "$remote_list" >> debug.log
echo "$local_list" >> debug.log

# Upload sorted local files to dropbox (most recent files)
# for file_name in "${local_list[@]}"; do
#     # Upload file to dropbox
#     ./dropbox_uploader.sh -q -s -f $config_file upload $local_backup_folder/$file_name $remote_backup_folder
# done

# # Loop through remote_list
# index=0
# while read -r line; do
#     # Skip first line
#     if [ $index -eq 0 ]; then
#         index=1
#         continue
#     fi

#     # Increment index
#     index=$((index+1))

#     # Get file name
#     file_name=$(echo $line | awk '{print $3}')

#     # Check if file exists in local_list array
#     if [[ " ${local_list[@]} " =~ " $file_name " ]]; then
#         # File exists in local folder
#     else
#         # Delete file from dropbox
#         ./dropbox_uploader.sh -q -f $config_file delete $file_name
#     fi
# done <<< "$remote_list"

# # Clean up
# rm dropbox_uploader.sh
