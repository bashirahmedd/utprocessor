#!/bin/bash

# path to the usb folder to modify time stamp of the files
cd /media/naji/MediaStick/Kids_videos  

# find specific files
files=$(find . -type f -name '*.mpg' | shuf)

# use newline as file separator (handle spaces in filenames)
IFS=$'\n'

let day_sec="24*60*60"       # a single day in sec
epoc_val=`date +%s`          # init epoch val
echo "Init Epoch : ${epoc_val}"

for f in ${files}
do
    # touch -t $(date -v -1m -r $(stat -f %m  "${f}") +%Y%m%d%H%M.%S) "${f}"
    #stat "${f}"
    echo "${f}"
    epoc_val="$(($epoc_val - $day_sec))"
    touch  -am --date=@"$epoc_val"  "${f}"
    #stat "${f}" 
    #echo "${epoc_val}"    
    #break
done
