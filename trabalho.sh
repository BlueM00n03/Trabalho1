#!/bin/bash
c_flag='false'
while getopts 'cbr:' flag; do
  case "${flag}" in
    c) c_flag='true' ;;
    b) b_flag='true' ;;
    r) r_flag='true'
        r_arg=${OPTARG};;
    *) echo "Invalid option: -${OPTARG}" >&2; exit 1 ;;
  esac
done




