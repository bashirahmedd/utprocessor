#!/bin/bash

# https://onlinelinuxtools.com/escape-shell-characters

# includes are order specific
source ./include/script_speech.sh      
source ./include/script_signal.sh

# file structure required to amplify sound file
in_dir="/home/naji/Downloads/temp/ytdown/process/temp"
out_dir="${in_dir}""/"
backup_dir="${in_dir}""/backup/"
src_dir="${in_dir}""/input/"

# log files
counter=`date +%s`
failure_out="./log/""$counter""_failure_mp3_lame.log"
success_out="./log/""$counter""_success_mp3_lame.log"
 
let slp_val="2+2+2"       #in sec
echo "reading from path: $in_dir"
let by_scale="4"
while : ; do
    #fn_process_signal   

    while read -r fname; do
        # echo $fname
        # fn_process_signal   

        if [ -d "$out_dir" -a -d "$backup_dir" -a -d "$src_dir" ]; then
            if [ -f "$fname" ]; then
                in_file=$(basename "$fname")
                echo "$in_file"           
                out_fname="$out_dir""${in_file%.*}""-""$by_scale""x.mp3"
                
                lame --scale "$by_scale" "$fname" "$out_fname"
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
    done <<< "`find  "$src_dir" -type f -name '*.mp3' | sort`"

    fn_say "Getting ready for next iteration".
    sleep $slp_val
done