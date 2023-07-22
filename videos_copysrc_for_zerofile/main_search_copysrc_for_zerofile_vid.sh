#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

# includes are order specific
#source ./include/script_speech.sh      
#source ./include/script_signal.sh

# vars for new download
counter=`date +%s`
in_dir="/home/naji/Downloads/temp/ytdown/process/temp"
out_dir="$in_dir""/"
backup_dir="$in_dir""/backup/"
src_dir="${in_dir}""/input/"

#search_dir="/home/naji/bashir-workspace/kids_corner/420p/usb1/"
search_dir="/home/naji/bashir-workspace/kids_corner/420p/usb1_archived/"

failure_out="./log/""$counter""_failure_mp4_mpg.log"
success_out="./log/""$counter""_success_mp4_mpg.log"
 
let slp_val="2+2+2"       #in sec
echo "reading from path: $in_dir"

# find specific files
vid_files=$(find "$src_dir" -type f -name '*' | sort)
# use newline as file separator (handle spaces in filenames)
IFS=$'\n'

for fname in ${vid_files}
do
    # echo "${fname}"        
    if [ -d "$out_dir" -a -d "$backup_dir" -a -d "$src_dir" ]; then
        if [ -f "$fname" ]; then
            in_file=$(basename "$fname")
            echo "$in_file"
            quote_in_file=$(printf '%q' "$in_file")
            
            #out_fname="$fname"".mpg"                   
            vid_found=$(find "$search_dir" -type f -name "$quote_in_file""*" )
            #echo "$vid_found"
            
            if [ -f "$vid_found" ]; then
                cp "$vid_found" "$out_dir"  
                mv "$fname" "$backup_dir"          # move processed file to backup
                echo "$in_file" >>  $success_out
            else
                echo "$in_file" >>  $failure_out
            fi
        else
            fn_say "Non Existing File: "
            echo "$fname"
            if [ -z "$fname" ]; then
                echo "Process completed, exiting"
                exit 0
            fi
        fi
    else
        fn_say "Either: Not found ""$out_dir"
        fn_say "or: Not found ""$src_dir"
        fn_say "or: Not found ""$backup_dir"
        exit -1
    fi
done