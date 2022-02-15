#!/bin/bash

slp_val="$((60*1))" 
target='/home/naji/bashir-workspace/github_bashirahmedd/green_madookh'
cd $target
while : ; do
    pwd
    git push

    if [ $? -ne 0 ];then
        echo "Failed..."
        sleep $slp_val
    else
        echo "Success..."
        break
    fi
done