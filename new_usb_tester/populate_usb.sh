#!/bin/bash

usb_base_path="/media/naji/EAAA-49C0/"
source_file_path="/home/naji/My_App/LosslessCut-linux.AppImage"
for i in {1..460}; do
    target_path=$usb_base_path$i"-LosslessCut-Linux.AppImage"
    START_TIME=$(date +%s)
    cp "$source_file_path" "$target_path"    
    echo "Elapsed time to copy: "$(( $(date +%s)-START_TIME ))
    echo "$target_path" 
    #sleep 1
    chmod +x "$target_path"       
    #break
done

