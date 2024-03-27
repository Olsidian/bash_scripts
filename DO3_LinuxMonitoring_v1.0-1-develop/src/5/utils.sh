#!/bin/bash

# Функция для проверки количества аргументов и форматирования пути к директории
check_and_format_directory() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 /path/to/directory/"
        exit 1
    fi
    local directory=$1
    [[ "$directory" != */ ]] && directory="$directory"/
    echo "$directory"
}

# Функция для поиска и форматирования информации о крупнейших файлах
list_top_files() {
    local directory=$1
    local count=$2
    find "$directory" -type f -exec du -h {} + | sort -hr | head -$count | awk '{
        file=$2; size=$1"B";
        n = split(file, parts, ".");
        if(n > 1) {ext = parts[n];} else {ext = "none";}
        print file",", size",", ext
    }' | nl -w1 -s " - /" | sed 's/$/,/'
}
