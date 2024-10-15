#!/bin/bash
c_flag='false'
while getopts 'abf:v' flag; do
  case "${flag}" in
    c) c_flag='true' ;;
  esac
done