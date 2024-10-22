#!/bin/bash

function backup() {
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
                        if [[ $c_flag == "false" ]]; then
                            cp -a "$file" "$file2"
                        fi
                        echo "cp -a ""$file" "$file2"
                    fi
                fi
            
            done
            if [[ $found_flag == "false" ]];then
                if [[ $c_flag == "false" ]]; then
                    cp -a "$file" "$target_dir/$filename"
                fi        
                echo "cp -a $file" "$target_dir/""$filename"
            fi
        fi
    done
    for file in "$target_dir"/*; do
        if [ -f "$file" ];then
            filename=$(basename "$file")
            found_flag=false
            for file2 in "$working_dir"/*; do
                file2_name=$(basename "$file2")
                if [[ "$filename" == "$file2_name" ]]; then
                    found_flag=true
                fi
            done
            if [[ $found_flag == "false" ]];then
                echo "rm $file" 
                rm $file
            fi
        fi
    done
}
backup "$1" "$2"