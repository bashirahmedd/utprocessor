#!/bin/bash

all_merged_urls='./output/next_iteration.txt' 
rm "$all_merged_urls"

fileNames=`ls -rt *_result.txt`

for file in $fileNames;do

    echo $file
    cat $file >> all_merged_urls.txt
    rm $file
done