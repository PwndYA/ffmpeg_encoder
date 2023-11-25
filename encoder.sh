#!/bin/bash

# Directory where the files are located
dir="/path/to/.mkv/files"

read -p "WARNING: If the script is executed, files in the output folder with the same name will be overwritten. Continue? (Yes/No) " confirm
confirm=${confirm,,}

# Check the user's response
if [[ $confirm =~ ^(yes|y)$ ]]; then
    # Create the output directory if not exist
    mkdir -p "$dir/encoded"

    output_codecs=""

    # Loop over all .mkv files in the directory
    for file in "$dir"/*.mkv; do
        # Extract audio
        codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")

        # Check not AC3
        if [ "$codec" != "ac3" ]; then
            # Extract the base name of the file
            base=$(basename "$file")

            # Convert audio stream to AC3
            ffmpeg -i "$file" -map 0:v -map 0:a:0 -c:v copy -c:a ac3 "$dir/encoded/$base"

            # mediainfo check
            output_codec=$(mediainfo --Inform="Audio;%Format%" "$dir/encoded/$base")
            output_codecs+="$base: $output_codec\n"
        fi
    done

    # Print Variable to CLI
    echo -e "\nNew codec of the files:\n$output_codecs\n"
else
    echo "Script cancelled."
fi
