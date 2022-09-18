#!/bin/bash

all_merged_urls='./output/all_merged_urls.txt' 
rm "$all_merged_urls"

#fileNames=`ls -rt *_result.txt`
fileNames=`ls -rt ./output/vds_*.txt`

for file in $fileNames;do
    echo $file
    cat $file >> all_merged_urls.txt
    rm $file
done