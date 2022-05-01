#!/bin/bash

#start new list download
next_iteration='next_iteration.txt'                 #must be empty file in start
#rm try_urls_again.txt
channel_urls='channel_urls.txt'
#cptobase='/home/bashir/Downloads'
#target='./ytdown/'
filelines=`cat $channel_urls`
#filelines=`head -1 $channel_urls`
#echo $filelines
#startNum=`date +%s`
counter=`date +%s`
inc=1 
#startNum=$(($(date +'%s * 1000 + %-N / 1000000')))
#https://www.youtube.com/channel/UCGtQ_4B3IhxSl2AG-HmVWrg/videos
base_url='https://www.youtube.com/channel/'

for line in $filelines;do

    #currentNum=`date +%s`
    #currentNum=$(($(date +'%s * 1000 + %-N / 1000000')))
    #echo $currentNum"-"$startNum
    #counter="$(($currentNum-$startNum))"
    counter="$(($counter+$inc))"
    #printf -v frm_counter "%03d" $counter
    #outputFile=$counter"_queue.txt"
    outputFile="vds_"$counter"_"$line".txt"
    #echo $outputFile
    #youtube-dl -f 'best[ext=mp4]+best[height<=480]/best' -o $target$outputFile $line
    #youtube-dl -f 22/18/17 -o $target$outputFile $line
    #youtube-dl -j --flat-playlist $line | jq -r '.id' | sed 's_^_https://www.youtube.com/watch?v=_' >> $outputFile  
    echo $line
    echo 'Output = '$outputFile
    youtube-dl -j --flat-playlist $base_url$line"/videos" | jq -r '.url' >> $outputFile
    if [ ! -s $outputFile ]
      then
        echo "failed: $line"
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
    cat $next_iteration > $channel_urls
    cat /dev/null > $next_iteration
fi

