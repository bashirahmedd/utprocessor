#!/bin/bash

#start new list download
rm try_urls_again.txt
filename='script_input_video_id.txt'
#cptobase='/home/bashir/Downloads'
baseUrl='https://www.youtube.com/watch?v='
target='./ytdown/'
filelines=`cat $filename`
#filelines=`head -1 $filename`
#echo $filelines
#startNum=`date +%s`
counter=`date +%s`
inc=1 
#startNum=$(($(date +'%s * 1000 + %-N / 1000000')))

for line in $filelines;do
    echo $line
    #currentNum=`date +%s`
    #currentNum=$(($(date +'%s * 1000 + %-N / 1000000')))
    #echo $currentNum"-"$startNum
    #counter="$(($currentNum-$startNum))"
    counter="$(($counter+$inc))"
    #printf -v frm_counter "%03d" $counter
    outputFile=$counter"_%(title)s.%(ext)s"
    #echo $outputFile
    #youtube-dl -f 'best[ext=mp4]+best[height<=480]/best' -o $target$outputFile $line
    youtube-dl -f 22/18/17 -o $target$outputFile "https://www.youtube.com/watch?v="$line

    if [ $? -ne 0 ]
      then
        echo "failed: $line"
        echo $line >>  try_urls_again.txt
        #echo $outputFile'\t'$line >>  try_urls_again.txt
        #break
    else
        echo "success: $line"
    fi
    #break
done

