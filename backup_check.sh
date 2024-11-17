#!/bin/bash

function usage(){
    echo "Usage: ./backup_check.sh dir_trabalho dir_backup">&2
}

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

if [[ $# != 2 ]]; then
    usage
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
                hashf1=($(md5sum $file))
                hashf2=($(md5sum $file2))
                if [[ ! $hashf1 == $hashf2 ]]; then
                    echo "file "$file2" "$file" differ."
                fi
            fi
        fi
    done
done
