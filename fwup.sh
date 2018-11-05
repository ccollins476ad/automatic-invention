#!/bin/bash -e

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <device group> <hardware ID> <file_containing_build_id>"
    exit 1
fi

dg=$1
hwid=$2
build_id=$(cat $3)

echo $RUNTIME_CI_LINK

runtime job fwup -g $dg -d $hwid -i $build_id -w --timeout=20m
