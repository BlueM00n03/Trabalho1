#!/bin/bash
while getopts 'cb:r:' flag; do
        case "${flag}" in
        c) echo c ;;
        b) echo b 
            echo ${OPTARG};;
        r) echo r
            echo ${OPTARG};;
        /?) echo "Invalid option: -${OPTARG}" >&2; exit 1 ;;
        esac
    done

echo "$@"

echo "${@:1:$#-1}" one
