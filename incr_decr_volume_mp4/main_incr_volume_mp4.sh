#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

in_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/read_2_ladybird_novel'
out_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/read_2_ladybird_novel/out/'
let slp_val="2+2"       #in sec

while read -r fname; do

    if [ -d "$out_dir" ]; then
        in_file=$(basename "$fname")
        echo "$in_file"
        ffmpeg -i "$fname" -af volume=100 -vcodec copy "$out_dir""$in_file"
        if [ $? -eq 0 ]; then
            sleep $slp_val
        fi
    else
        echo "Error: Not found ""$out_dir"
    fi

done <<< "`find  $in_dir -type f`"
