#!/bin/bash

# Padding left and right black pixels
# Width-to-Height Ratio (Aspect Ratio): 16:9

# Create an output directory to avoid overwriting originals
mkdir -p padded_output

for file in *.mp4; do
    echo "Processing $file..."

    # 1. Extract current Height (H) and Width (W)
    H=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$file")
    W=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$file")

    # 2. Calculate target width for 16:9 ratio
    # Formula: (H * 16 / 9). We ensure the result is an even integer for codec compatibility.
    TARGET_W=$(echo "($H * 16 / 9 + 1) / 2 * 2" | bc)
    echo "$TARGET_W"

    # 3. Apply padding only if the target width is greater than current width
    if [ "$TARGET_W" -gt "$W" ]; then
        ffmpeg -i "$file" -vf "pad=$TARGET_W:$H:(ow-iw)/2:(oh-ih)/2:black" -c:a copy "padded_output/${file%.mp4}_padded.mp4"
    else
        echo "Skipping $file: Already at or wider than 16:9 ratio."
    fi
done

echo "Batch processing complete."