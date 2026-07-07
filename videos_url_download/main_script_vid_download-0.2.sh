#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

# includes are order specific
source ./include/script_speech.sh                    # google tts to read aloud text
source ./include/script_signal.sh
session_dl_sz=0
source ./include/script_util.sh

#activate virtual env for yt-dlp 
source ~/yt-dlp/bin/activate                
yt_version=`yt-dlp --version`
fn_say "yt-dlp version available: "$yt_version

#args
batch="$1"
fn_say "Loading Batch # ""$batch"

# Dependency Check: Check for JS runtime required by yt-dlp
if ! command -v node &> /dev/null && ! command -v deno &> /dev/null; then
   fn_say "Warning: No JavaScript runtime (node/deno) detected. Downloads may be slow or fail."
fi

# vars for new download
counter=`date +%s`
in_video_list="./input/""$batch""_video_id.txt"                 # ids are loaded here
try_again_video_list="./input/""$batch""_next_iteration.txt"    # must be empty file in start
backup_id="./log/""$counter""_backup_video_id.log"   # overwrite this file
skipped_video_list="./log/""$counter""_skipped_video_id.log"
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
skipped_video_count=0

slp_val="$((60*5))"       # in sec
slp_inc=60                # increment by 60 sec
max_video_duration_minutes=35
max_video_duration_seconds="$(($max_video_duration_minutes*60))"

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

        # yt-dlp reports duration in seconds.
        video_duration_seconds=`yt-dlp --no-warnings --print "%(duration)s" "$in_file" 2>/dev/null`

        if [[ "$video_duration_seconds" =~ ^[0-9]+$ && "$video_duration_seconds" -gt "$max_video_duration_seconds" ]];then
            video_duration_minutes="$((($video_duration_seconds+59)/60))"
            echo "skipped: $line ($video_duration_minutes minutes, limit is $max_video_duration_minutes minutes)"
            echo "$line" >> "$skipped_video_list"
            skipped_video_count="$(($skipped_video_count+1))"
            fn_say "Skipping task "$task_num" out of "$task_tot" because it is longer than "$max_video_duration_minutes" minutes."
        else
            #youtube-dl --no-mtime -f 22/18/17 -o $out_file $in_file
            #youtube-dl -F "$line"|grep -E '^(18|17|22)'
            yt-dlp -F "$line"|grep -E '^(18|17|22)'
            yt-dlp --no-warnings -F "$line" 2>/dev/null | grep -E '^(18|17|22)'
            #youtube-dl --no-mtime -r 4.2M -c -f 22/18/17 -o $out_file $in_file
            #youtube-dl --no-mtime -r 4.2M -c -f 18/17/22 -o $out_file $in_file
            #yt-dlp --no-mtime -r 4.2M -c -f 18/17/22 -o $out_file $in_file
            yt-dlp --js-runtimes "deno:/home/naji/.deno/bin/deno" --remote-components "ejs:npm" --no-mtime -r 4.2M -c -f 18/17/22 -o $out_file $in_file

            if [[ $? -ne 0 ]];then
                echo "failed: $line"
                echo $line >>  $try_again_video_list
                fn_say "Unfortunately! task "$task_num" out of "$task_tot" has failed."            
            else
                fn_process_fsize "$in_file" 
                echo "success: $line"
                fn_say "Hooray! task "$task_num" out of "$task_tot" is successful. Skipped videos so far: "$skipped_video_count"." 
            fi
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

# Skipped videos are intentional, so they should not fail validation.
validate_id="$backup_id"
if [[ -s "$skipped_video_list" ]];then
    validate_id="./log/""$counter""_expected_download_id.log"
    grep -Fvx -f "$skipped_video_list" "$backup_id" > "$validate_id"
fi
fn_validate_file "$target" "$validate_id" 
fn_say "Given batch is downloaded successfully."
