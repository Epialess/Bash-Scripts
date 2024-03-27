#!/bin/bash

# This script checks if a given disk or file systems is mounted — 
# that is, accessible by the computer’s file system

is_mounted() {
    mountpoint -q "$1"
    if [ $? -eq 0 ]; then
        echo "$1 is mounted."
        report_space "$1"
    else
        echo "$1 is not mounted."
    fi
}

report_space() {
    local mount=$1
    echo "Space usage for $mount:"
    df -h "$mount" | awk 'NR==2 {print "Used space: " $3 ", Free space: " $4}'
}

mount_point="/mnt/data"

is_mounted "$mount_point"