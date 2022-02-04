#!/bin/bash

#usb_base_path="/media/naji/EAAA-49C0/"
usb_base_path="/home/naji/Downloads/USB_File_System_Problem/imagedump/EAAA-49C0/"
corrupt_log_path="corrupt_apps.log"
rm "$corrupt_log_path" 2> /dev/null &                 #init log file
ftot=$(ls "$usb_base_path"|wc -l)
ftot="$(($ftot+1))"
echo "Last file Id: ${ftot}"
#exit 1

app_nme="-LosslessCut-Linux.AppImage"

for ((cnt=1; cnt <= $ftot; cnt++)); do
    rslv_app_nme="$cnt$app_nme"
    echo "$rslv_app_nme"
    if [ -f "$FILE" ]; then
        START_TIME=$(date +%s)
        "$usb_base_path""$rslv_app_nme" &
        END_TIME=$(date +%s)
        echo "Elapsed time to execute: "$(( END_TIME-START_TIME ))
        sleep 5
        app_proc_ids=`pgrep -x losslesscut`
        if [ -z "$app_proc_ids" ]; then
            echo "App is corrupt:$rslv_app_nme"
            echo "$rslv_app_nme" >> "$corrupt_log_path"
        else
            for proc_id in $app_proc_ids; do 
                echo "kill: $proc_id" 
                kill "$proc_id"                
            done
        fi  
    else
        echo "File not found: $rslv_app_nme"
    fi      
    #break
done
