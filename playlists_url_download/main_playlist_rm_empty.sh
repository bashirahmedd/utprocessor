#!/bin/bash


in_dir="/home/naji/bashir-workspace/github_bashirahmedd/utprocessor/playlists_url_download/output"

while read -r fname; do
    #echo "$fname"
    if [ -f "$fname" -a ! -s "$fname" ]; then
        echo "$fname"
        rm "$fname"
    fi
done <<< "`find  $in_dir -type f `"