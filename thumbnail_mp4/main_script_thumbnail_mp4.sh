#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

# includes are order specific
source ./include/script_speech.sh      
source ./include/script_signal.sh

# vars for new download
counter=`date +%s`
base_files_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/math_1_gen'
target_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/math_1_gen/'
let slp_val="2+2"       #in sec

for fname in "$base_files_dir"/*; do 
    fn_process_signal   
    
    if [ -f "$fname" ]; then  
        file_name=$(basename "$fname")
        vid_len=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$fname"`

        if [ $? -eq 0 ]; then
            vid_len1=`echo "$vid_len/1 - 2" | bc`
            # video start and end thumbnail 
            sleep $slp_val
            ffmpeg -i "$fname" -ss 00:00:02 -frames:v 1 -y "$target_dir""$file_name"".start.jpeg"

            if [ $? -eq 0 ]; then
                sleep $slp_val
                ffmpeg -ss "$vid_len1" -i "$fname" -ss 00:00:01 -frames:v 1 -y "$target_dir""$file_name"".end.jpeg"
                sleep $slp_val
            fi
        fi
        # echo "$vid_len"
        # echo "$vid_len1"
        # echo "$fname"
        # break
    else
        fn_say "Non Existing File: ""$fname"
        if [ -z "$fname" ]; then
            echo "Process completed, exiting"
            exit 0
        fi
    fi
done

exit 0

while : ; do

    while read -r full_name; do
        # fn_process_signal   
        
        # if [ -f "$full_name" ]; then  
        #     file_name=$(basename "$full_name")
        #     vid_len=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$full_name"`

        #     if [ $? -eq 0 ]; then
        #         vid_len1=`echo "$vid_len/1 - 2" | bc`
        #         # video start and end thumbnail 
        #         sleep $slp_val
        #         ffmpeg -i "$full_name" -ss 00:00:02 -frames:v 1 -y "$target_dir""$file_name"".start.jpeg"

        #         if [ $? -eq 0 ]; then
        #             sleep $slp_val
        #             ffmpeg -ss "$vid_len1" -i "$full_name" -ss 00:00:01 -frames:v 1 -y "$target_dir""$file_name"".end.jpeg"
        #             sleep $slp_val
        #         fi
        #     fi
        #     # echo "$vid_len"
        #     # echo "$vid_len1"
        #     # echo "$full_name"
        #     break
        # else
        #     fn_say "Non Existing File: ""$fname"
        #     if [ -z "$fname" ]; then
        #         echo "Process completed, exiting"
        #         exit 0
        #     fi
        # fi
    done <<< "`find  $base_files_dir -type f`"

    fn_say "Getting ready for next iteration".
    sleep $slp_val
done