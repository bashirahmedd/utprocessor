#!/bin/bash

file_req_ext=".mp3"
next_iteration='next_iteration.txt'                 #must be empty file in start
file_names='file_names.txt'
base_dir='/home/naji/bashir-workspace/kids_corner/420p/usb1/read_father_aud'

if [ -s $file_names -a ! -s $next_iteration ];then
    echo "Processing previous entries: $file_names is not empty"
else
    echo "Loading file names list into $file_names"
    ls -a $base_dir | grep -i 'mp3' | sort > $file_names
fi

exit 0
#cd "$base_dir"
while read line; do
    echo "$line"
    file_ext=`echo $line|tail -c 5`
    echo "$file_ext"

    if [[ "$file_req_ext" == "$file_ext" ]]

        dir_name=${line::-4}

        full_path="$base_dir/$dir_name"
        file_path="$base_dir/$line"
        if [ -d "$full_path" ] 
        then
            echo "Duplicate paths not allowed $full_path" 
            echo $line >>  $next_iteration
        else
            mp3splt -a -t 20.0 -o Lesson_01-@n -d "$full_path" "$file_path"
            echo "success: $line"
        fi
    else
        echo "Invalid file type "
    fi
    #break 1
done < $file_names

if [[ ! -s $next_iteration ]];then
    exit 0
else
    cat $next_iteration > $file_names
    cat /dev/null > $next_iteration
fi
