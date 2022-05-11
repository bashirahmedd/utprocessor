#!/bin/bash
target_dir="/home/naji/Downloads/temp/ytdown/audio_books_backup/Albert Einstein - Theory of Relativity - FULL AudioBook - Quantum Mechanics - Astrophysics"
cd "$target_dir"

while read file_name; do
    eyeD3 --title="${file_name%.*}" "$file_name"
    echo $file_name
done <<< "$(ls -1 *.mp3 | sort)"