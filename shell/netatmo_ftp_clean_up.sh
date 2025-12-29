#!/bin/bash

folder="/share/netatmo/"
# 30 Gb = 31,457,280 Kb
max_size=31457280

function clean_up_empty_folders () {
    find $folder -depth -empty -delete
}

function remove_old_files () {
    total_size=$(du -cks $folder | grep total | sed 's/|/ /' | awk '{print $1, $8}')

    if [ $total_size -gt $max_size ]
    then
        # remove the oldest file
        oldest_file=$(find $folder -type f | sort | head -n 1)
        [[ ! -z "$oldest_file" ]] && rm "$oldest_file"
        remove_old_files
    else
        clean_up_empty_folders
    fi

    # Remove files older than 2 days in snapshots folder
    find /share/netatmo/snapshots/sonnette -type f -mtime +1 -exec rm {} \;
    find /share/netatmo/snapshots/backyard -type f -mtime +1 -exec rm {} \;
    find /share/netatmo/snapshots/home -type f -mtime +1 -exec rm {} \;
}

remove_old_files