#!/bin/bash

#start new list download
next_iteration='./input/next_iteration.txt'           #must be empty file in start
playlists_urls='./input/playlists_urls.txt'
filelines=`cat $playlists_urls`
counter=`date +%s`
inc=1 
base_url='https://www.youtube.com/watch?list='

for line in $filelines;do

    counter="$(($counter+$inc))"
    outputFile="./output/vds_json_"$counter"_"$line".json"  #tab separated
    #echo $outputFile
    echo $line
    echo 'Output = '$outputFile
    #youtube-dl -j --flat-playlist $base_url$line | jq -r '.id+" , "+.title' >> $outputFile
    #youtube-dl -j --flat-playlist $base_url$line | jq -r '.id+"\t"+.title' >> $outputFile
    youtube-dl -j --flat-playlist $base_url$line | jq '.' >> $outputFile
    
    if [ ! -s $outputFile ]
      then
        echo "failed: $line"
        rm "$outputFile"       #rm empty file
        #echo $line >>  try_urls_again.txt
        echo $line >>  $next_iteration
        #break
    else
        echo "success: $line"
    fi
    #break
done

if [[ ! -s $next_iteration ]];then
    exit 0
else
    cat $next_iteration > $playlists_urls
    cat /dev/null > $next_iteration
fi

