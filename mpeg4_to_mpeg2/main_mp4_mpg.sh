#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

# includes are order specific
source ./include/script_speech.sh      
source ./include/script_signal.sh

# vars for new download
counter=`date +%s`
in_dir="/home/naji/bashir-workspace/kids_corner/420p/usb_mom"
out_dir="$in_dir""/"
backup_dir="$in_dir""/backup/"
failure_out="./log/""$counter""_failure_mp4_mpg.log"
success_out="./log/""$counter""_success_mp4_mpg.log"
 
let slp_val="2+2+2"       #in sec

while : ; do
    #fn_process_signal   

    while read -r fname; do
        # echo $fname
        # fn_process_signal   

        if [ -d "$out_dir" -a -d "$backup_dir" ]; then
            if [ -f "$fname" ]; then
                in_file=$(basename "$fname")
                echo "$in_file"
               ffmpeg -y -i "$fname" -c:v mpeg2video -q:v 5 -c:a mp2 -f vob "$fname"".mpg"
                if [ $? -eq 0 ]; then            
                    sleep $slp_val
                    mv "$fname" "$backup_dir"          # move processed file to backup
                    echo "$in_file" >>  $success_out
                else
                    echo "$in_file" >>  $failure_out
                fi
            else
                fn_say "Non Existing File: ""$fname"
                if [ -z "$fname" ]; then
                    echo "Process completed, exiting"
                    exit 0
                fi
            fi
        else
            fn_say "Either: Not found ""$out_dir"
            fn_say "or: Not found ""$backup_dir"
            exit -1
        fi
    done <<< "`find  $in_dir -type f -not -path '*/out/*' -not -path '*/backup/*' -name '*.mp4'`"

    fn_say "Getting ready for next iteration".
    sleep $slp_val
done