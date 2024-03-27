#!/bin/bash

# This script uses recursion to implement a countdown generator. 
# The script accepts a positive integer as input 
# and then print each number in descending order until it reaches 0. 
# Upon reaching 0, it will display "BLAST OFF!".

countdown() {
    local num=$1
    echo $num
    if [ $num -gt 0 ]; then
        countdown $((num - 1))
    else
        echo "BLAST OFF!"
    fi
}

# Check if the input is a positive integer
if ! [[ $1 =~ ^[0-9]+$ ]] || [ $1 -lt 1 ]; then
    echo "Please provide a positive integer as input."
    exit 1
fi

countdown $1
