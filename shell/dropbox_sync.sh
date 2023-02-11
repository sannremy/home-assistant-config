#!/bin/bash

# Pre-requisites:
#   1. Execute dropbox_uploader.sh in order to generate the config file
#   2. Copy the config file to the home directory AS /config/shell/.dropbox_uploader

# Usage:
# ./dropbox_sync.sh remote_backup_folder keep_last

config_file="/config/shell/.dropbox_uploader"
remote_backup_folder=$1
keep_last=$2

# Download dropbox_uploader.sh and make it executable
curl -s "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
chmod +x dropbox_uploader.sh

# Compare files in dropbox and local folder
remote_list=$(./dropbox_uploader.sh -f $config_file list $remote_backup_folder)
local_list=$(curl -sSL -H "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/backups | jq -r '.data.backups |= sort_by(.date)' | jq -r '[.data.backups[] | .slug] | reverse | .[]')

# Upload sorted local files to dropbox (most recent files)
index=0
while read -r slug; do
    # Upload only the last $keep_last files
    if [ $index -lt $keep_last ]; then
        output="/tmp/$slug.tar"
        # Fetch backup file from supervisor
        curl -s -H "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/backups/$slug/download --output $output

        # Upload file to dropbox
        ./dropbox_uploader.sh -q -s -f $config_file upload $output $remote_backup_folder

        # Clean up
        rm $output
    else
        # Delete file from local folder
        curl -s -X DELETE -H "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/backups/$slug
    fi

    index=$((index+1))

done <<< "$local_list"

# Take only the most recent files
local_list=$(echo $local_list | head -n $keep_last)

# Remove files from Dropbox that are not in local folder
# Loop through remote_list
index=0
while read -r line; do
    # Skip first line
    if [ $index -eq 0 ]; then
        index=1
        continue
    fi

    # Get file name
    file_name=$(echo $line | awk '{print $3}')

    # Check if file exists in local_list
    if echo $local_list | grep -q $file_name; then
        # File exists in local folder
        echo "File $file_name exists in local folder"
    else
        # Delete file from dropbox
        ./dropbox_uploader.sh -q -f $config_file delete $file_name
    fi
done <<< "$remote_list"

# Clean up
rm dropbox_uploader.sh
