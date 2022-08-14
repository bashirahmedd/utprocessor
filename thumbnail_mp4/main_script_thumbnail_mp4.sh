#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

base_files_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1'
target_dir='/home/naji/Downloads/temp/ytdown/others/'

while read -r full_name; do
    echo "$full_name"
    file_name=$(basename "$full_name")
    vid_len=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$full_name"`
    vid_len1=`echo "$vid_len/1 - 1" | bc`
     
    #video start and end thumbnail 
    ffmpeg -i "$full_name" -ss 00:00:01 -frames:v 1 -y "$target_dir""$file_name"".start.jpeg"
    ffmpeg -ss "$vid_len1" -i "$full_name" -ss 00:00:01 -frames:v 1 -y "$target_dir""$file_name"".end.jpeg"
done <<< "`find  $base_files_dir -type f`"
