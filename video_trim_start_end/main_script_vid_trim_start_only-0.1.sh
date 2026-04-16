#!/bin/bash


# -------- configuration --------
# Run the script from the current folder of the video source directory using sh /fullscript_file.sh 
# sh /home/naji/bashir_workspace/software_dev/utprocessor/video_trim_start_end/main_script_vid_trim_start_only-0.1.sh


mkdir -p trimmed_videos
for f in *.mp4; do
    
    filename=$(basename "$f")
    echo "Processing $filename"

    # -b:a 64k sets a low bitrate to save space
    ffmpeg -ss 00:00:08  -i "$f" -c:v copy -c:a aac -b:a 64k "trimmed_videos/${f%.mp4}_trimmed.mp4"

done

echo "Done."