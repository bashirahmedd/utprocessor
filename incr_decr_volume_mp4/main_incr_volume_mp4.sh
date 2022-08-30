#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

# includes are order specific
source ./include/script_speech.sh      
source ./include/script_signal.sh

# vars for new download
counter=`date +%s`
in_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/math_1_gen'
out_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/math_1_gen/out/'
backup_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/math_1_gen/backup/'
failure_out="./log/""$counter""_failure_incr_volume_mp4.log"
success_out="./log/""$counter""_success_incr_volume_mp4.log"
 
let slp_val="2+2+2"       #in sec

while : ; do
    #fn_process_signal   

    while read -r fname; do
        #echo $fname
        fn_process_signal   

        if [ -d "$out_dir" -a -d "$backup_dir" ]; then
            if [ -f "$fname" ]; then
                in_file=$(basename "$fname")
                #echo "$in_file"
                ffmpeg -y -i "$fname" -filter:a "volume=3.00" "$out_dir""$in_file"
                if [ $? -eq 0 ]; then            
                    sleep $slp_val
                    mv "$fname" "$backup_dir"          # move processed file to backup
                    echo "$in_file" >>  $success_out
                else
                    echo "$in_file" >>  $failure_out
                fi
            else
                echo "Non Existing File: ""$fname"
                if [ -z "$fname" ]; then
                    echo "Process completed, exiting"
                    exit 0
                fi
            fi
        else
            echo "Either: Not found ""$out_dir".
            echo "or: Not found ""$backup_dir".
        fi
    done <<< "`find  $in_dir -type f -not -path '*/out/*' -not -path '*/backup/*'`"

    echo "Getting ready for next iteration".
    sleep $slp_val
done