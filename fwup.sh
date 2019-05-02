#!/bin/bash -e

if [[ $# -lt 5 ]]; then
    echo "Usage: $0 <device group> <hardware ID> <build ID file 1> <build ID file 2>"
    exit 1
fi

dg=$1
hwid=$2
build_a=$(cat $3)
build_b=$(cat $4)

echo $RUNTIME_CI_LINK

current=$(runtime device state -g $dg -d $hwid | jq -r .build_id)

function run_upgrade {
    if fwup_out=$(runtime job fwup -g $1 -d $2 -i $3 -w --timeout=25m); then
        echo "Success: $fwup_out"
    else 
        echo "error from gateway: $fwup_out"
        exit 1
    fi
}

if [[ $current = $build_a ]]; then
    run_upgrade $dg $hwid $build_b
else 
    run_upgrade $dg $hwid $build_a
fi
