#!/bin/bash

source utils.sh

start_time=$(date +%s.%N)

 if [ "$#" -ne 1 ]; then
        echo "Usage: $0 /path/to/directory/"
        exit 1
    fi

directory=$1

# Ensure the path ends with '/'
[[ "$directory" != */ ]] && directory="$directory"/

# Total number of folders
total_folders=$(find "$directory" -type d | wc -l)

# Top 5 largest folders formatted
top_5_folders=$(du -h --max-depth=1 "$directory" | sort -hr | head -5 | awk '{print $2", " $1"B"}' | nl -w1 -s " - /" | sed 's/$/,/')


# Total number of files
total_files=$(find "$directory" -type f | wc -l)

# Types of files formatted
conf_files=$(find "$directory" -type f -name "*.conf" | wc -l)
text_files=$(find "$directory" -type f -name "*.txt" | wc -l)
executable_files=$(find "$directory" -type f -executable | wc -l)
log_files=$(find "$directory" -type f -name "*.log" | wc -l)
archive_files=$(find "$directory" -type f | grep -E ".tar.gz$|.zip$" | wc -l)
symbolic_links=$(find "$directory" -type l | wc -l)

# Top 10 largest files formatted


top_10_files=$(list_top_files "$directory" 10)

# Top 10 largest executable files with MD5 formatted
top_10_exec_files_md5=$(find "$directory" -type f -executable -exec du -h {} + | sort -hr | head -10 |\
awk '{print $2}' | xargs -I {} sh -c 'size=$(du -h "{}" | cut -f1); md5=$(md5sum "{}" | cut -d" " -f1); echo "{}" "$size"B"," "$md5"' |\
awk '{ sub(/\.[^.]+$/, ".exe,", $1); print $0 }' | nl -w1 -s " - /")


end_time=$(date +%s.%N)
elapsed=$(echo "$end_time - $start_time" | bc)

echo "Total number of folders (including all nested ones) = $total_folders"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
echo "$top_5_folders"
echo "Total number of files = $total_files"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $conf_files"
echo "Text files = $text_files"
echo "Executable files = $executable_files"
echo "Log files (with the extension .log) = $log_files"
echo "Archive files = $archive_files"
echo "Symbolic links = $symbolic_links"
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
echo "$top_10_files"
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
echo "$top_10_exec_files_md5"
echo "Script execution time (in seconds) = $elapsed"



