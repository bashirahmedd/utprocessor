#!/bin/bash

ext="$1"
all_merged_urls='./output/all_merged_urls.txt' 

echo "$ext"
if [ ! -z "$ext" ];then
    
    if [ -f "$all_merged_urls" ];then
        rm "$all_merged_urls"
    fi

    fileNames=`ls -rt ./output/vds_*."$ext"`

    for file in $fileNames;do
        echo $file
        cat $file >> "$all_merged_urls"
        rm $file
    done

else
    echo "Please give required target file extension json or txt"
    echo "e.g. ./main_combine_urls.sh json"
fi