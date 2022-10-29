#!/bin/bash

all_merged_urls='./output/all_merged_urls.txt' 

if [ -f "$all_merged_urls" ];then
    rm "$all_merged_urls"
fi

fileNames=`ls -rt ./output/vds_*.txt`

for file in $fileNames;do
    echo $file
    cat $file >> "$all_merged_urls"
    rm $file
done