#!/bin/bash

# # -------- configuration --------
# INPUT_DIR="/path/to/input/videos"
# OUTPUT_DIR="/path/to/output/videos"

# START_TIME="00:01:30"
# END_TIME="00:02:10"
# # --------------------------------

# mkdir -p "$OUTPUT_DIR"

# for f in "$INPUT_DIR"/*.mp4; do
#     filename=$(basename "$f")
#     echo "Processing $filename"

#     ffmpeg -ss "$START_TIME" -to "$END_TIME" -i "$f" -c copy "$OUTPUT_DIR/cut_$filename"
# done

# echo "Done."

# -------- configuration --------
# Run the script from the current folder of the video source directory using sh /fullscript_file.sh 
# sh /home/naji/bashir_workspace/software_dev/utprocessor/video_trim_start_end/main_script_vid_trim_start_end-0.1.sh


mkdir -p trimmed_videos
for f in *.mp4; do

    filename=$(basename "$f")
    echo "Processing $filename"

    # 1. Get total duration in seconds
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")
    
    # 2. Calculate the stop point (Duration - 10s)
    # Using 'bc' for floating point math: T_stop = duration - 10
    t_stop=$(echo "$duration - 31" | bc)
    
    # 3. Trim from 6s to the calculated stop point
    # We re-encode audio (-c:a aac) to ensure sync at both cut points
    # ffmpeg -ss 00:00:06 -to "$t_stop" -i "$f" -c:v copy -c:a aac -b:a 192k "trimmed_videos/${f%.mp4}_trimmed.mp4"

    ffmpeg -ss 00:00:46 -to "$t_stop" -i "$f" -c:v copy -c:a aac -b:a 64k -ar 22050 "trimmed_videos/${f%.mp4}_trimmed.mp4"
done

echo "Done."
