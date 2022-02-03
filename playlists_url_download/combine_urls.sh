#!/bin/bash

rm all_merged_urls.txt

fileNames=`ls -rt *_result.txt`

for file in $fileNames;do

    echo $file
    cat $file >> all_merged_urls.txt
    rm $file
done