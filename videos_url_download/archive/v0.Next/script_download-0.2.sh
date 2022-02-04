#!/bin/bash

#includes
source script_tts.sh

#start new download
script_input_video_id='input_video_id.txt'      #ids are loaded here 
try_id_again='try_id_again.txt'                 #must be empty file in start
backup_id='input_video_id_backup.txt'           #overwrite this file     
if [ -s $script_input_video_id -a ! -s $try_id_again ];then
   echo "Initial state is good..." 
   cat $script_input_video_id > $backup_id      #backup intial ids
   echo "Input ids are backed-up to $backup_id"
else
   echo "Initial state is invalid, please check:"    
   echo "Either file is empty:  $script_input_video_id"
   echo "or file is not empyt: $try_id_again"
   exit 1 
fi

baseUrl='https://www.youtube.com/watch?v='
target='./ytdown/'
counter=`date +%s`
inc=1 
filelines=`cat $script_input_video_id`

slp_val="$((60*5))"       #in sec
slp_inc=60                #increment by 60 sec  
#echo "$slp_val"
#exit 1

echo "Starting download..."
while : ; do
    for line in $filelines;do
        echo $line        
        outputFile=$counter"_%(title)s.%(ext)s"
        youtube-dl -f 22/18/17 -o $target$outputFile "https://www.youtube.com/watch?v="$line
        if [ $? -ne 0 ];then
            echo "failed: $line"
            echo $line >>  $try_id_again
        else
            echo "success: $line"
        fi
        counter="$(($counter+$inc))"
    done

    if [ ! -s $try_id_again ];then
        break
    else
        cat $try_id_again > $script_input_video_id
        cat /dev/null > $try_id_again
        filelines=`cat $script_input_video_id`

        sleep $slp_val
        slp_val="$(($slp_val+$slp_inc))"  #increment for next iteration
    fi
done
say "All the given ids downloaded successfully..."

