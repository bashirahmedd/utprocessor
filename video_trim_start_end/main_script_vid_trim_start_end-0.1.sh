#!/bin/bash

# -------- configuration --------
INPUT_DIR="/path/to/input/videos"
OUTPUT_DIR="/path/to/output/videos"

START_TIME="00:01:30"
END_TIME="00:02:10"
# --------------------------------

mkdir -p "$OUTPUT_DIR"

for f in "$INPUT_DIR"/*.mp4; do
    filename=$(basename "$f")
    echo "Processing $filename"

    ffmpeg -ss "$START_TIME" -to "$END_TIME" -i "$f" -c copy "$OUTPUT_DIR/cut_$filename"
done

echo "Done."