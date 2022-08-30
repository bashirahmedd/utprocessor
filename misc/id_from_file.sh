#!/bin/bash

counter=`date +%s`
in_dir='/home/naji/bashir-workspace/kids_corner/420p/usb2/read_4_novel'

while read -r fname; do
    #echo $fname
    id="${fname:(-17)}"  
    id="${id:0:11}"  
    echo "$id"  
done <<< "`find  $in_dir -type f`"