#!/bin/bash

for f in *.mp4; do ffmpeg -i "$f" -vn  -acodec libmp3lame -ac 2 -ab 96k -ar 48000 "$(basename "$f" .mp4).mp3"; done