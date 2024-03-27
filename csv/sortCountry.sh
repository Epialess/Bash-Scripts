#!/bin/bash

# This script takes in a cvs file and outputs it into two columns: 
# in this case, one for the country and the other for its capital.

# Data retrieved from:
# https://github.com/icyrockcom/country-capitals/blob/master/data/country-list.csv

# Check arguments
if [ $# -ne 1 ]; then
    echo "Error-Usage: $0 <CSV_FILE>"
    exit 1
fi

CSV_FILE=$1

awk -F, '{printf "%-50s %-50s\n", $1,$2}' "$CSV_FILE" | tr -d '"'

# This section only outputs countries that starts with a given letter
letter="B"
awk -F, -v prefix="\"$letter" '$1 ~ "^"prefix' "$CSV_FILE" | cut -d',' -f1 | tr -d '"'

