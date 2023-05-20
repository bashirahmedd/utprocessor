#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

# includes are order specific
source ./include/script_speech.sh                    # google tts to read aloud text
source ./include/script_signal.sh
session_dl_sz=0
source ./include/script_util.sh

#args
batch="$1"
fn_say "Loading Batch # ""$batch"

# vars for new download
counter=`date +%s`
in_video_list="./input/""$batch""_video_id.txt"                 # ids are loaded here
try_again_video_list="./input/""$batch""_next_iteration.txt"    # must be empty file in start
backup_id="./log/""$counter""_backup_video_id.log"   # overwrite this file
separator="-----------------------------"

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
echo "$separator"
while : ; do
    # process a given download 
    task_num=1
    for line in $filelines;do
        fn_process_signal   
        
        if ! grep -Fxq -- "$line" "$in_video_list"; then
            fn_say " ID is removed, Not Found: ""$line"
            echo "$separator"
            continue
        fi

        echo "Batch # ""$batch"" Target file id: ""$line"        
        #out_file=$target$counter"_%(title)s_%(uploader)s_"$line".%(ext)s"
        out_file=$target"%(title)s_%(uploader)s_"$line".%(ext)s"
        in_file="https://www.youtube.com/watch?v="$line

        #youtube-dl --no-mtime -f 22/18/17 -o $out_file $in_file
        youtube-dl -F "$line"|grep -E '^(18|17|22)'
        youtube-dl --no-mtime -r 4.2M -c -f 22/18/17 -o $out_file $in_file

        if [[ $? -ne 0 ]];then
            echo "failed: $line"
            echo $line >>  $try_again_video_list
            fn_say "Unfortunately! task "$task_num" out of "$task_tot" has failed."            
        else
            fn_process_fsize "$in_file" 
            echo "success: $line"
            fn_say "Hooray! task "$task_num" out of "$task_tot" is successful." 
        fi
        sed -i '1d' "$in_video_list" 
        counter="$(($counter+$inc))"
        task_num="$(($task_num+1))"
        
        vqueue=`cat $in_video_list|wc -l`
        tagain=`cat $try_again_video_list|wc -l`
        vpending="$(($vqueue+$tagain))"
        echo "Active queue : "$vqueue" Queued again : "$tagain" Pending Vids : "$vpending
        echo "$separator"
    done

    if [[ ! -s $try_again_video_list ]];then
        break
    else
        cat $try_again_video_list > $in_video_list
        cat /dev/null > $try_again_video_list
        filelines=`cat $in_video_list`

        slp_val="$(($slp_val+$slp_inc))"          # increment for next iteration
        echo "Current Date and Time is: "`date +"%Y-%m-%d %T"` 
        fn_say "Runing next iteration in "$slp_val" seconds."

        task_tot=`cat $in_video_list|wc -l`
        fn_say "The next iteration has "$task_tot" tasks in total."

        fn_say "Download size in the session is "$session_dl_sz
        sleep $slp_val
        echo "$separator"
    fi
done

#fix illegal char : in the file name
rename 's/:/_/g' "$target""*.mp4"

fn_say "Validating downloads"
fn_validate_file "$target" "$backup_id" 
fn_say "Given batch is downloaded successfully."

