#!/bin/bash
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
        *) echo "Invalid option: -${flag}" >&2 ; exit 1 ;;
        esac
    done
    shift $((OPTIND-1))
    if [[ ! -d "$2" ]]; then
        if [[ -d "$1" ]]; then
            mkdir "$2"
            echo "The destiny directory didn't exist but was created."
        fi
    else
        echo "Warning: The source directory ($1) does not exist."
        exit 1
    fi
    working_dir="$1"
    target_dir="$2"
    for file in "$working_dir"/*; do
        if [[ $b_flag == 'true' ]];then
            if grep -Fxq "$file" "$b_arg"
            then
                continue
            fi

        fi
        if [ -f "$file" ];then
            if [[ $r_flag == 'true' ]];then
                if ! [[ $file =~ $r_arg ]];then
                    continue
                fi
            fi
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
        elif [[ -d "$file" ]];then
            ./backup.sh "${args[@]:0: ${#args[@]}-2}" "2" "${args[@]: -1}"
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
                    rm $file
                fi
            fi
        fi
    done
