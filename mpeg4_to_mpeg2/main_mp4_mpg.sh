#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

# includes are order specific
source ./include/script_speech.sh      
source ./include/script_signal.sh

# vars for new download
counter=`date +%s`
in_dir="/home/naji/Downloads/temp/ytdown/process/temp"
out_dir="$in_dir""/"
backup_dir="$in_dir""/backup/"
src_dir="${in_dir}""/input/"

failure_out="./log/""$counter""_failure_mp4_mpg.log"
success_out="./log/""$counter""_success_mp4_mpg.log"
 
let slp_val="2+2+2"       #in sec
echo "reading from path: $in_dir"
while : ; do
    #fn_process_signal   

    while read -r fname; do
        # echo $fname
        # fn_process_signal   

        if [ -d "$out_dir" -a -d "$backup_dir" -a -d "$src_dir" ]; then
            if [ -f "$fname" ]; then
                in_file=$(basename "$fname")
                echo "$in_file"
                out_fname="$fname"".mpg"
                out_fname="$out_dir""${in_file%.*}"".mpg"
                ffmpeg -y -i "$fname" -c:v mpeg2video -q:v 5 -c:a mp2 -f vob "$out_fname"
                if [ $? -eq 0 ]; then  
                    if [[ $(stat -c%s "$out_fname") -ge $(stat -c%s "$fname") ]]; then          
                        sleep $slp_val
                        mv "$fname" "$backup_dir"          # move processed file to backup
                        echo "$in_file" >>  $success_out
                    else
                        echo "$in_file" >>  $failure_out
                    fi
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
    done <<< "`find  $src_dir -type f -name '*.mp4' | sort`"

    fn_say "Getting ready for next iteration".
    sleep $slp_val
done