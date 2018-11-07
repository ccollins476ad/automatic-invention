#!/bin/bash -e

if [[ $# -lt 4 ]]; then
    echo "Usage: $0 <device group> <hardware ID> <build ID file 1> <build ID file 2>"
    exit 1
fi

dg=$1
hwid=$2
build_a=$(cat $3)
build_b=$(cat $4)

echo $RUNTIME_CI_LINK

current=$(runtime device state -g rt-test -d f5f3e2eb64502638a4224861972c717a | jq -r .build_id)

if [[ $current = $build_a ]]; then
    runtime job fwup -g $dg -d $hwid -i $build_b -w --timeout=20m
else
    runtime job fwup -g $dg -d $hwid -i $build_a -w --timeout=20m
fi
