#!/bin/bash
#pip install youtube-dl --upgrade

#set -euo pipefail 

#includes are sequence specific
source ./include/script_speech.sh     #google tts to read aloud text
shutdown_signal_file='./signal/shutdown'
source ./include/script_shutdown.sh   
exit_signal_file='./signal/exit'
source ./include/script_exit.sh


#start new download
script_input_video_id='./input/video_id.txt'      #ids are loaded here 
try_id_again='./input/next_iteration.txt'                 #must be empty file in start
backup_id='./input/backup_video_id.txt'           #overwrite this file     
if [ -s $script_input_video_id -a ! -s $try_id_again ];then
   fn_say "Initial state is good..."
   cat $script_input_video_id > $backup_id      #backup intial ids
   fn_say "Input id list is backed up."
   echo "backed-up to "$backup_id   
else
   fn_say "Initial state is invalid, please check:"
   fn_say "Either, the file is empty:  $script_input_video_id"
   fn_say "or the file is not empty: $try_id_again"
   exit 1 
fi

baseUrl='https://www.youtube.com/watch?v='
target='/home/naji/Downloads/temp/ytdown/'
counter=`date +%s`
inc=1 
filelines=`cat $script_input_video_id`
task_tot=`cat $script_input_video_id|wc -l`

slp_val="$((60*5))"       #in sec
slp_inc=60                #increment by 60 sec  

#echo "$slp_val"
#exit 1

fn_say "Starting download of "$task_tot" tasks."
while : ; do
    #check exit signal
    # if [[ -f "$exit_signal" ]]; then
    #     fn_say "Stop Called"
    #     fn_say "Please do manual merge of input_id and try_again files."
    #     exit 0
    # fi

    #processs task 
    task_num=1
    for line in $filelines;do
        fn_shutdown_signal   
        fn_exit_signal
        echo $line        
        #outputFile=$counter"_"$line"_%(title)s.%(ext)s"
        outputFile=$counter"_%(title)s_"$line".%(ext)s"
        youtube-dl --no-mtime -f 22/18/17 -o $target$outputFile "https://www.youtube.com/watch?v="$line
        #youtube-dl --no-mtime -f 18/17 -o $target$outputFile "https://www.youtube.com/watch?v="$line
        
        if [[ $? -ne 0 ]];then
            echo "failed: $line"
            echo $line >>  $try_id_again
            fn_say "Unfortunately! task "$task_num" out of "$task_tot" has failed."
        else
            echo "success: $line"
            fn_say "Hooray! task "$task_num" out of "$task_tot" is successful." 
        fi
        sed -i '1d' "$script_input_video_id" 
        counter="$(($counter+$inc))"
        task_num="$(($task_num+1))"
    done

    if [[ ! -s $try_id_again ]];then
        break
    else
        cat $try_id_again > $script_input_video_id
        cat /dev/null > $try_id_again
        filelines=`cat $script_input_video_id`

        
        slp_val="$(($slp_val+$slp_inc))"  #increment for next iteration
        fn_say "Runing next iteration in "$slp_val" seconds."

        task_tot=`cat $script_input_video_id|wc -l`
        fn_say "The next iteration has "$task_tot" tasks in total."

        sleep $slp_val
    fi
done
fn_say "Given batch is downloaded successfully."

