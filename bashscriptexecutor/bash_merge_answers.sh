#!/bin/bash

# Set the directory path
directory_path="/home/naji/Downloads/StudentAssignments"

cd "$directory_path"

# Specify the output file
output_file="merged_output.txt"

# Use find to locate all text files in the directory and its subdirectories
find "$directory_path" -type f -name "answer*.txt" | while read -r file; do

    # Add two blank lines before echoing the file name
    echo -e "\n\n=== $file ===\n" >> "$output_file"
    
    # Concatenate the file contents
    cat "$file" >> "$output_file"
    
    # Add two blank lines after echoing the file name
    echo -e "\n\n==================================================" >> "$output_file"
done

echo "Merging complete. Output saved to $output_file"

