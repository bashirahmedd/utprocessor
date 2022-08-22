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
