#!/bin/bash

set -u

OUTPUT_DIR="vertical_videos"
mkdir -p "$OUTPUT_DIR"

found_mp4=0
moved_count=0

for file in *.mp4; do
    if [ ! -e "$file" ]; then
        continue
    fi

    found_mp4=1
    echo "Checking $file..."

    dimensions=$(ffprobe -v error \
        -select_streams v:0 \
        -show_entries stream=width,height \
        -of csv=p=0:s=x \
        "$file")

    if [ -z "$dimensions" ]; then
        echo "Skipping $file: could not read video dimensions."
        continue
    fi

    width=${dimensions%x*}
    height=${dimensions#*x}

    if [ "$height" -gt "$width" ]; then
        mv "$file" "$OUTPUT_DIR/"
        echo "Moved $file to $OUTPUT_DIR/ (width=$width, height=$height)"
        moved_count=$((moved_count + 1))
    else
        echo "Keeping $file in place (width=$width, height=$height)"
    fi
done

if [ "$found_mp4" -eq 0 ]; then
    echo "No .mp4 files found in the current directory."
    exit 0
fi

echo "Done. Moved $moved_count vertical video(s) to $OUTPUT_DIR/."
