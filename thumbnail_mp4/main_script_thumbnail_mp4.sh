#!/bin/bash
pip install youtube-dl --upgrade

#set -euo pipefail 

base_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1'

while read -r fname; do
    #echo "$fname"
    ffmpeg -i "$fname" -ss 00:00:01 -frames:v 1 "$fname"".jpeg"
done <<< "`find  $base_dir -type f`"
