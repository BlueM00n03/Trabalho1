#!/bin/bash

function backup_files() {
    if [ -d "$1" ]; then
    if [ ! -d "$2" ]; then
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
    for x in "$working_dir"/*; do
        if [ -f "$x" ];then
            date $x; 
            echo $x
        fi

    
done
}
backup_files "$1"