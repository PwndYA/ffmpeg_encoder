#!/bin/bash

# File Direcotry
dir="/path/to/your/files"

# Create the output directory if it doesn't exist
mkdir -p "$dir/encoded"

# Loop over all .mkv files in the directory
for file in "$dir"/*.mkv; do
    # Extract the audio codec
    codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")

    # Check if the codec is not AC3
    if [ "$codec" != "ac3" ]; then
        # Extract the base name of the file
        base=$(basename "$file")

        # Convert the audio stream to AC3
        ffmpeg -i "$file" -map 0:v -map 0:a:0 -c:v copy -c:a ac3 "$dir/encoded/$base"
    fi
done
