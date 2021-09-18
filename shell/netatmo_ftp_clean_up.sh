#!/bin/bash

folder="/media/netatmo/"
# 20 Gb = 20,971,520 Kb
max_size=20971520

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
}

remove_old_files
