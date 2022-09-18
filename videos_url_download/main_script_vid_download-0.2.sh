#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

# includes are order specific
source ./include/script_speech.sh                    # google tts to read aloud text
source ./include/script_signal.sh
session_dl_sz=0
source ./include/script_util.sh

# vars for new download
counter=`date +%s`
in_video_list='./input/video_id.txt'                 # ids are loaded here
try_again_video_list='./input/next_iteration.txt'    # must be empty file in start
backup_id="./log/""$counter""_backup_video_id.log"   # overwrite this file

# validate state
if [ -s $in_video_list -a ! -s $try_again_video_list ];then
   fn_say "Initial state is good..."
   cat $in_video_list > $backup_id           # backup intial ids
   fn_say "Input id list is backed up."
   echo "backed-up to "$backup_id   
else
   fn_say "Initial state is invalid, please check:"
   fn_say "Either, the file is empty:  $in_video_list"
   fn_say "or the file is not empty: $try_again_video_list"
   exit 1 
fi

baseUrl='https://www.youtube.com/watch?v='
target='/home/naji/Downloads/temp/ytdown/'

inc=1 
filelines=`cat $in_video_list`
task_tot=`cat $in_video_list|wc -l`

slp_val="$((60*5))"       # in sec
slp_inc=60                # increment by 60 sec

fn_say "Starting download of "$task_tot" tasks."
while : ; do
    # process a given download 
    task_num=1
    for line in $filelines;do
        fn_process_signal   
        
        echo "Target file id: ""$line"        
        out_file=$target$counter"_%(title)s_"$line".%(ext)s"
        in_file="https://www.youtube.com/watch?v="$line

        youtube-dl --no-mtime -f 22/18/17 -o $out_file $in_file

        if [[ $? -ne 0 ]];then
            echo "failed: $line"
            echo $line >>  $try_again_video_list
            fn_say "Unfortunately! task "$task_num" out of "$task_tot" has failed."
            echo "-----------------------------"
        else
            fn_process_fsize "$in_file" 
            echo "success: $line"
            fn_say "Hooray! task "$task_num" out of "$task_tot" is successful." 
            echo "-----------------------------"
        fi
        sed -i '1d' "$in_video_list" 
        counter="$(($counter+$inc))"
        task_num="$(($task_num+1))"
        
    done

    if [[ ! -s $try_again_video_list ]];then
        break
    else
        cat $try_again_video_list > $in_video_list
        cat /dev/null > $try_again_video_list
        filelines=`cat $in_video_list`

        slp_val="$(($slp_val+$slp_inc))"          # increment for next iteration
        fn_say "Runing next iteration in "$slp_val" seconds."

        task_tot=`cat $in_video_list|wc -l`
        fn_say "The next iteration has "$task_tot" tasks in total."

        fn_say "Download size in the session is "$session_dl_sz
        sleep $slp_val
    fi
done
fn_say "Validating downloads"
fn_validate_file "$target" "$backup_id" 
fn_say "Given batch is downloaded successfully."

