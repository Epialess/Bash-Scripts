#!/bin/bash

# A network monitoring script
# This program pings to a list of hosts and then logs its
# ping results into a log file.

# List of hosts to monitor, separated by spaces
HOSTS="1.1.1.1 youtube.com 8.8.8.8"

# Default log file location is the location of the script
LOGFILE="$(pwd)/networkMonitor.log"

# Ping timeout
TIMEOUT=5

# Current date and time
echo "Starting network monitoring - $(date)" | tee -a "$LOGFILE"

check_connectivity() {
    local host=$1
    ping -c 1 -W $TIMEOUT $host | tee -a "$LOGFILE"
    # &> /dev/null
    if [ $? -eq 0 ]; then
        echo "SUCCESS: Ping to $host successful" | tee -a "$LOGFILE"
    else
        echo "FAILURE: Ping to $host failed" | tee -a "$LOGFILE"
    fi
}

# Loop through each host
for host in $HOSTS; do
    check_connectivity $host
done

echo "Network monitoring completed - $(date)" | tee -a "$LOGFILE"
