#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

in_dir='/home/naji/bashir-workspace/kids_corner/420p/usb2/read_4_novel'
out_dir='/home/naji/bashir-workspace/kids_corner/420p/usb2/read_4_novel/out/'
let slp_val="2+2"       #in sec

while read -r fname; do
   
    in_file=$(basename "$fname")
    echo "$in_file"
    ffmpeg -i "$fname" -af volume=100 -vcodec copy "$out_dir""$in_file"

done <<< "`find  $in_dir -type f`"
