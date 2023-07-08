#!/bin/bash

# path to the usb folder to modify time stamp of the files
cd /home/naji/bashir-workspace/kids_corner/420p/usb1/phonics_0  
src_dir="/home/naji/bashir-workspace/kids_corner/420p/usb_mom""/"

# find specific files
files=$(find "$src_dir" -type f -name '*.mpg' | shuf)

# use newline as file separator (handle spaces in filenames)
IFS=$'\n'

for f in ${files}
do
   echo "${f}"
done
