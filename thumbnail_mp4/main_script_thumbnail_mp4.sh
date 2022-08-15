#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

base_files_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/read_ladybird'
target_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/read_ladybird/'
slp_val="$((2+2))"       #in sec

while read -r full_name; do
   
    file_name=$(basename "$full_name")
    vid_len=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$full_name"`
    vid_len1=`echo "$vid_len/1 - 2" | bc`
     
    #video start and end thumbnail 
    sleep $slp_val
    ffmpeg -i "$full_name" -ss 00:00:02 -frames:v 1 -y "$target_dir""$file_name"".start.jpeg"
    sleep $slp_val
    ffmpeg -ss "$vid_len1" -i "$full_name" -ss 00:00:01 -frames:v 1 -y "$target_dir""$file_name"".end.jpeg"
    sleep $slp_val

    echo "$vid_len"
    echo "$vid_len1"
    echo "$full_name"
    # break
done <<< "`find  $base_files_dir -type f`"
