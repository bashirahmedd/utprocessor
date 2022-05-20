#!/bin/bash
pip install youtube-dl --upgrade

#set -euo pipefail 

source ./include_speech.sh     #google tts to read aloud text
exit_signal='exit_signal.txt'

#start new download
script_input_video_id='input_video_id.txt'      #ids are loaded here 
try_id_again='next_iteration.txt'                 #must be empty file in start
backup_id='input_video_id_backup.txt'           #overwrite this file     
if [ -s $script_input_video_id -a ! -s $try_id_again ];then
   say "Initial state is good..."
   cat $script_input_video_id > $backup_id      #backup intial ids
   say "Input id list is backed up."
   echo "backed-up to "$backup_id   
else
   say "Initial state is invalid, please check:"
   say "Either file is empty:  $script_input_video_id"
   say "or file is not empyt: $try_id_again"
   exit 1 
fi

baseUrl='https://www.youtube.com/watch?v='
#target='./ytdown/'
target='/home/naji/Downloads/temp/ytdown/'
counter=`date +%s`
inc=1 
filelines=`cat $script_input_video_id`
task_tot=`cat $script_input_video_id|wc -l`

slp_val="$((60*5))"       #in sec
slp_inc=60                #increment by 60 sec  

#echo "$slp_val"
#exit 1

say "Starting download of "$task_tot" tasks."
while : ; do
    #check exit signal
    if [[ -f "$exit_signal" ]]; then
        say "Stop Called"
        say "Please merge input and try_again ids files."
        exit 0
    fi

    #processs task 
    task_num=1
    for line in $filelines;do
        echo $line        
        #outputFile=$counter"_"$line"_%(title)s.%(ext)s"
        outputFile=$counter"_%(title)s_"$line".%(ext)s"
        youtube-dl -f 22/18/17 -o $target$outputFile "https://www.youtube.com/watch?v="$line
        if [[ $? -ne 0 ]];then
            echo "failed: $line"
            echo $line >>  $try_id_again
            say "Unfortunately! task "$task_num" out of "$task_tot" has failed."
        else
            echo "success: $line"
            say "Hooray! task "$task_num" out of "$task_tot" is successful." 
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
        say "Runing next iteration in "$slp_val" seconds."

        task_tot=`cat $script_input_video_id|wc -l`
        say "The next iteration has "$task_tot" tasks in total."

        sleep $slp_val
    fi
done
say "Given batch is downloaded successfully."

