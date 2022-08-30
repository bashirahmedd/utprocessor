#!/bin/bash
#pip install youtube-dl --upgrade

ffmpeg -i "$fname" -filter:a "volume=.20" "$out_dir""$in_file"