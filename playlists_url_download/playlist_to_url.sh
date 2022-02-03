#!/bin/bash

#start new list download
rm try_urls_again.txt
filename='playlists_urls.txt'
#cptobase='/home/bashir/Downloads'
#target='./ytdown/'
filelines=`cat $filename`
#filelines=`head -1 $filename`
#echo $filelines
#startNum=`date +%s`
counter=`date +%s`
inc=1 
#startNum=$(($(date +'%s * 1000 + %-N / 1000000')))
base_url='https://www.youtube.com/watch?list='

for line in $filelines;do

    #currentNum=`date +%s`
    #currentNum=$(($(date +'%s * 1000 + %-N / 1000000')))
    #echo $currentNum"-"$startNum
    #counter="$(($currentNum-$startNum))"
    counter="$(($counter+$inc))"
    #printf -v frm_counter "%03d" $counter
    #outputFile=$counter"_queue.txt"
    outputFile="queue_"$counter".txt"
    #echo $outputFile
    #youtube-dl -f 'best[ext=mp4]+best[height<=480]/best' -o $target$outputFile $line
    #youtube-dl -f 22/18/17 -o $target$outputFile $line
    #youtube-dl -j --flat-playlist $line | jq -r '.id' | sed 's_^_https://www.youtube.com/watch?v=_' >> $outputFile  
    echo $line
    echo 'Output = '$outputFile
    youtube-dl -j --flat-playlist $base_url$line | jq -r '.id' >> $outputFile
    if [ ! -s $outputFile ]
      then
        echo "failed: $line"
        echo $line >>  try_urls_again.txt
        #break
    else
        echo "success: $line"
    fi
    #break
done

