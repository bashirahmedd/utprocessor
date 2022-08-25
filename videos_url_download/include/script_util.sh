#!/bin/bash

fn_process_fsize() 
{
    echo "argument sent:""$1"
    #curr_file_sz=`youtube-dl -f 22/18/17 $1 -j | jq .filesize`
    #echo "Target raw file size: ""$curr_file_sz"
    #fl_sz=`numfmt --to=iec "$curr_file_sz"`
    #echo "Target file size: ""$fl_sz" 
    # if echo "$curr_file_sz" | grep -qE '^[0-9]+$'; then
    #     session_dl_sz="$(($session_dl_sz+$curr_file_sz))"
    # fi
}

fn_validate_file()
{
    target='/home/naji/Downloads/temp/ytdown/'
    while read -r fid; do
        echo "$fid"
        fname=`ls "$target"|grep -i "$fid"".mp4$"`
        echo $fname
    done <<< "`cat ./input/backup_video_id.txt `"
}

fn_remove_partial()
{
    echo "fn_remove_partial"
}

#fn_validate_file