#!/bin/bash

# A simple system monitoring tool that checks CPU usage, memory usage, and disk space, 
# sends alerts, and logs its results.

# Dependencies: sysstat

# Default log file location is the directory of the script
LOGFILE="$(pwd)/systemMonitor.log"

# Current date and time
# echo "$(date)" | tee -a "$LOGFILE"
TIMESTAMP=$(date +%d-%m-%Y" "%H:%M:%S)

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Get current usage values
CPU_USAGE=$(mpstat 1 1 | awk '/Average:/ {print 100 - $NF}')
MEM_USAGE=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//g')

# If log file doesnt exists add header to logfile
if [ ! -e "$LOGFILE" ]; then
    echo -e "CPU_USAGE%\tMEM_USAGE%\tDISK_USAGE%\tTIME" | tee -a "$LOGFILE"
else
	echo -e "CPU_USAGE%\tMEM_USAGE%\tDISK_USAGE%\tTIME"
fi

echo -e "$CPU_USAGE\t\t$MEM_USAGE\t\t$DISK_USAGE\t\t$TIMESTAMP" | tee -a "$LOGFILE"

# Check CPU usage
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
  echo "Alert: CPU usage is above threshold at ${CPU_USAGE}%" | tee -a "$LOGFILE"
fi

# Check memory usage
if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
  echo "Alert: Memory usage is above threshold at ${MEM_USAGE}%" | tee -a "$LOGFILE"
fi

# Check disk usage for root "/"
if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then
  echo "Alert: Disk usage is above threshold on / at ${DISK_USAGE}%" | tee -a "$LOGFILE"
fi

# echo "$(date)" | tee -a "$LOGFILE"
