#!/bin/bash
shopt -s dotglob

if [[ -d "$1" ]]; then
    if [[ ! -d "$2" ]]; then
        mkdir "$2"
        echo "The destiny directory didn't exist but was created."
    fi
else
    echo "Warning: The source directory ($1) does not exist."
    exit 1
fi

working_dir="$1"
target_dir="$2"

for file in "$target_dir"/*; do
    filename=$(basename "$file")
    for file2 in "$working_dir"/*; do
        file2_name=$(basename "$file2")
        if [[ "$filename" == "$file2_name" ]]; then    
            if [ -f "$file" ];then
                if [[ $(( $(md5sum $filename) - $(md5sum $file2_name) )) != 0 ]]; then
                    echo "file "$file2" "$file" differ."
                fi
            else
                ./backup_summary.sh "${@: -2}/$(basename "$file")" "$file"
            fi
        fi
    done
done
