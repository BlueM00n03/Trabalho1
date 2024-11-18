#!/bin/bash

function usage {
    echo "Usage: ./backup.sh [-c] [-b tfile] [-r regexpr] dir_trabalho dir_backup">&2
}

shopt -s dotglob

args=("$@")

c_flag='false'
b_flag='false'
r_flag='false'
while getopts ':cb:r:' flag; do
    case "${flag}" in
    c) c_flag='true' ;;

    b) b_flag='true' 
        b_arg=${OPTARG};;

    r) r_flag='true' 
        r_arg=${OPTARG};;

    *) usage; exit 1 ;;
    esac
done

shift $((OPTIND-1))

if [[ $# != 2 ]]; then
    usage
    exit 1
fi

if [[ -d "$1" ]]; then
    if [[ ! -d "$2" ]]; then
        mkdir "$2"
        echo "The destiny directory didn't exist but was created.">&2
    fi
else
    echo "Warning: The source directory ($1) does not exist.">&2
    exit 1
fi

working_dir="$1"
target_dir="$2"

for file in "$working_dir"/*; do 
    filename=$(basename "$file")
    if [[ $b_flag == 'true' ]];then
        if grep -Fxq "$filename" "$b_arg"
        then
            continue
        fi
        
    fi
    
    if [ -f "$file" ];then
        if [[ $r_flag == 'true' ]];then
            if ! [[ $filename =~ $r_arg ]];then
                continue
            fi
        fi

        found_flag=false
        for file2 in "$target_dir"/*; do
            file2_name=$(basename "$file2")
            if [[ "$filename" == "$file2_name" ]]; then
                found_flag=true
                if [[ $(date -r $file +%s) -gt $(date -r $file2 +%s) ]];then
                    echo "cp -a ""$file" "$file2"
                    if [[ $c_flag == "false" ]]; then
                        if ! cp -a "$file" "$file2";then
                            echo "Error: Failed to update $file to $file2">&2
                        fi
                    fi

                elif [[ $(date -r $file +%s) -lt $(date -r $file2 +%s) ]];then
                    echo "WARNING: backup entry $file2 is newer than $file; Should not happen">&2
                fi
            fi        
        done
        
        if [[ $found_flag == "false" ]];then
            echo "cp -a $file" "$target_dir/""$filename"
            if [[ $c_flag == "false" ]]; then
                if ! cp -a "$file" "$target_dir/$filename";then
                    echo "Error: Failed to copy $file to $target_dir$filename">&2
                fi                    
            fi        
        fi
    elif [[ -d "$file" ]];then
        if [[ ! -d "${args[@]: -1}/$(basename "$file")" ]];then
            mkdir "${args[@]: -1}/$(basename "$file")"
        fi
        ./backup.sh "${args[@]:0: ${#args[@]}-2}" "$file" "${args[@]: -1}/$(basename "$file")"
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
            if [[ $c_flag == "false" ]];then
                if ! rm $file;then
                    echo "Error: Failed to delete $file">&2
                fi
            fi
        fi
    fi
done