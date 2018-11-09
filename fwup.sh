#!/bin/bash -e

if [[ $# -lt 5 ]]; then
    echo "Usage: $0 <device group> <hardware ID> <build ID file 1> <build ID file 2> <build ID file 3>"
    exit 1
fi

dg=$1
hwid=$2
build_a=$(cat $3)
build_b=$(cat $4)
build_c=$(cat $5)

echo $RUNTIME_CI_LINK

current=$(runtime device state -g $dg -d $hwid | jq -r .build_id)

if [[ $current = $build_a ]]; then
    runtime job fwup -g $dg -d $hwid -i $build_b -w --timeout=20m
elif [[ $current = build_b ]]; then
    runtime job fwup -g $dg -d $hwid -i $build_c -w --timeout=20m
else 
    runtime job fwup -g $dg -d $hwid -i $build_a -w --timeout=20m
fi
