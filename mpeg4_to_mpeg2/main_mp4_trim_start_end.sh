#!/bin/bash

trim_sec_start=0
trim_sec_end=60

in_dir="/home/naji/Downloads/temp/ytdown/process/temp"
out_dir="$in_dir""/"
backup_dir="$in_dir""/backup/"
src_dir="${in_dir}""/input/"

failure_out="./log/""$counter""_failure_mp4_mpg.log"
success_out="./log/""$counter""_success_mp4_mpg.log"

let slp_val="2+2+2"       #in sec
echo "reading from path: $in_dir"

# find specific files
vid_files=$(find $src_dir -type f -name '*.mp4' | sort)
# use newline as file separator (handle spaces in filenames)
IFS=$'\n'

for fname in ${vid_files};do

    if [ -d "$out_dir" -a -d "$backup_dir" -a -d "$src_dir" ]; then
        if [ -f "$fname" ]; then
            echo "${fname}"    
            in_file=$(basename "$fname")
            vduration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "${fname}")
            echo "$vduration"
            duration=$(echo "$vduration-$trim_sec_end" | bc -l)
            echo "$duration"
            #duration=$(printf '%.0f\n' $duration)
            out_fname="$out_dir""${in_file%.*}"".mp4"
            ffmpeg -y -ss "$trim_sec_start" -to "$duration" -i "${fname}" -c copy "${out_fname}"

            if [ $? -eq 0 ]; then  
                if [[ $(stat -c%s "$out_fname") -le $(stat -c%s "$fname") ]]; then          
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
done
