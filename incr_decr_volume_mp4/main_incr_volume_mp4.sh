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

failure_out="./log/""$counter""_failure_incr_volume_mp4.log"
success_out="./log/""$counter""_success_incr_volume_mp4.log"
 
let slp_val="2+2+2"       #in sec

# while : ; do
#     #fn_process_signal   

#     while read -r fname; do

        #echo $fname
echo "reading from path: $in_dir"

# find specific files
vid_files=$(find "$src_dir" -type f -name '*.mp4' | sort)
# use newline as file separator (handle spaces in filenames)
IFS=$'\n'

for fname in ${vid_files}
do
    if [ -d "$out_dir" -a -d "$backup_dir" -a -d "$src_dir" ]; then
        if [ -f "$fname" ]; then
            in_file=$(basename "$fname")
            quote_in_file=$(printf '%q' "$in_file")  #linux escape file name to find
            echo "$in_file"
            echo "$quote_in_file"
            
            out_fname="$out_dir""${in_file%.*}""_a3.mp4"
            input_fname="$src_dir""$quote_in_file"
            #echo "$input_fname"
            #continue
            ffmpeg -y -i "$fname" -filter:a "volume=3.00" "$out_fname"
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
        fn_say "or: Not found ""$src_dir"
        fn_say "or: Not found ""$backup_dir"
        exit -1
    fi
    # done <<< "`find  $in_dir -type f -not -path '*/out/*' -not -path '*/backup/*'`"

    # fn_say "Getting ready for next iteration".
    # sleep $slp_val
done