#!/bin/bash

# Sample cmd service batchid
# $./batch_runner.sh  downloadVideos 1

#change the working directory
cd /home/naji/bashir-workspace/github_bashirahmedd/utprocessor/video_js_download/src/

#nodejs ytdl env variable
export YTDL_NO_UPDATE=1

#args
service="$1"
batch="$2"
echo "Running service: ""$service"" Batch ""$batch"

json_chunk_file="./data/chunk""$batch"".json"
echo "File being processed: ""$json_chunk_file"

if [ -f "$json_chunk_file" ]; then
    obj_tot=`jq length $json_chunk_file`

    while : ; do        
        echo "New Iteration, Total downloads queued :""$obj_tot" 
               
        for ((cnt=1; cnt <= $obj_tot; cnt++)); do
            node ./index.js "$service" "$batch"

            remaining=`jq length $json_chunk_file`
            echo "Total downloads queued :""$obj_tot"" remaining: ""$remaining"
        done

        obj_tot=`jq length $json_chunk_file`
        if [[ $obj_tot -eq 0 ]];then
            break
        fi
    done
else
    echo "File not found: $rslv_app_nme"
fi 