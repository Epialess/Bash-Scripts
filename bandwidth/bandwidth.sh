#!/bin/bash

# A script that measure the upload and download bandwidth 
# of a network once an hour and save the results in a log file

# To automate this script to run once an hour, use cron "crontab -e"
# and this command "0 * * * * /path/to/bandwidth_test.sh"

# Prerequisite: speedtest-cli

LOG_FILE="$(pwd)/logfile.log"

# Check if speedtest-cli is installed
if ! command -v speedtest-cli &> /dev/null; then
    echo "speedtest-cli not found. Install speedtest-cli to use this script - 'sudo apt-get install speedtest-cli'"
    exit 1
fi

OUTPUT=$(speedtest-cli --simple)

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Add to log file
echo "Timestamp: $TIMESTAMP" >> $LOG_FILE
echo "$OUTPUT" >> $LOG_FILE
echo "-----------------------------------" >> $LOG_FILE

echo "Bandwidth test completed and logged!"
