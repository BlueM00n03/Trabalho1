#!/bin/bash

function backup_files() {
    if [[ -d "$1" ]]; then
    if [[ ! -d "$2" ]]; then
        mkdir $2
        echo "The destiny directory didn't exist but was created."
    fi
    else
        echo "Warning: The source directory ($1) does not exist."
        exit 1
    fi
    working_dir="$1"
    target_dir="$2"
    c_flag='false'
    while getopts 'c' flag; do
        case "${flag}" in
        c) c_flag='true' ;;
        *) echo "Invalid option: -${OPTARG}" >&2; exit 1 ;;
        esac
    done
    for file in "$working_dir"/*; do
        if [ -f "$file" ];then
            filename=$(basename "$file")
            found_flag=false
            for file2 in "$target_dir"/*; do
                file2_name=$(basename "$file2")
                if [[ "$filename" == "$file2_name" ]]; then
                    found_flag=true
                    if [[ $(date -r $file +%s) -gt $(date -r $file2 +%s) ]];then
                        echo "cp -a ""$file" "$file2 12345"
                        cp -a "$file" "$file2"
                    fi
                fi
            
            done
            if [[ $found_flag == "false" ]];then
                echo "cp -a $file" "$target_dir/""$filename"
                cp -a "$file" "$target_dir/$filename"
            fi

        fi
    done
}
backup_files "$1" "$2"