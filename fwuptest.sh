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

function run_upgrade {
    if fwup_out=$(runtime job fwup -g $1 -d $2 -i $3 -w --timeout=20m); then
        echo "Success: $fwup_out"
    else 
        err=${fwup_out#"error: "}
        echo "error from gateway: $err"
        exit 1
    fi
}

if [[ $current = $build_a ]]; then
    run_upgrade $dg $hwid $build_b
elif [[ $current = $build_b ]]; then
    run_upgrade $dg $hwid $build_c
else 
    run_upgrade $dg $hwid $build_b
fi
