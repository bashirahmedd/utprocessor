#!/bin/bash

cd /home/naji/bashir-workspace/kids_corner/420p/usb1/math_0/temp
#find  $in_dir -type f
#find /home/naji/bashir-workspace/kids_corner/420p/usb1/math_0/temp -type f
#for i in *' '*; do mv "$i" `echo $i | sed -e 's/ /_/g'`; done
#find * -type f -name "* *" -exec rename "s/\s/_/g" {} \;
#find . -type f -name '*.mp4' -printf '%f\t%p\n' | sort -k1 >> join_video.txt
ffmpeg -f concat -safe 0 -i join_video.txt -c copy output.mp4
ffmpeg -f concat  -safe 0 -i join_video.txt -c copy output8.mp4

# while read -r fname; do
#     echo $fname >> mylist.txt
# done <<< "`find  "$in_dir" -type f -name  '*.mp4' -printf '%f\t%p\n'`"

#find . -type f -name '*.mp4' -printf '%f\t%p\n' | sort -k1 | cut -d$'\t' -f2
# https://www.bannerbear.com/blog/how-to-merge-video-files-using-ffmpeg/
# https://shotstack.io/learn/use-ffmpeg-to-concatenate-video/
# https://trac.ffmpeg.org/wiki/Concatenate
# :: Create File List
# for %%i in (*.mp4) do echo file '%%i'>> mylist.txt

# :: Concatenate Files
# ffmpeg -f concat -safe 0 -i mylist.txt -c copy output.mp4