#!/bin/bash

# A simple packet sniffer aka a network analyzer, protocol analyzer, or packet analyzer
# script with using tcpdump 
# The dumps are logged in the same directory as this script in a directory called "sniffer" 

# https://www.baeldung.com/linux/sniffing-packet-tcpdump

# Dependencies: tcpdump

INTERFACE="eth0" # Network interface to listen
DURATION=1 # Duration in seconds to capture, set to "0" for indefinite
OUTPUT_DIR="$(pwd)/sniffer"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
DUMP_FILE="${OUTPUT_DIR}/packet-captured-${TIMESTAMP}.pcap"

usage() {
    echo "Usage: $0 [-i interface] [-s seconds]"
    echo "Example: $0 -i eth0 -s 30"
    exit 1
}

while getopts "i:s:" opt; do
    case $opt in
        i) INTERFACE=$OPTARG;;
        s) DURATION=$OPTARG;;
        \?) usage;;
    esac
done
shift $((OPTIND -1))

# echo "Interface: $INTERFACE"
# echo "Duration: $DURATION"

start_capture() {
  echo "Starting packet capture on ${INTERFACE}..."
  if [ "$DURATION" -eq "0" ]; then
    # Indefinite capture
    tcpdump -i "$INTERFACE" -w "$DUMP_FILE" &
  else
    # Timed capture
    tcpdump -i "$INTERFACE" -w "$DUMP_FILE" &
    PID=$!
    sleep "$DURATION"
    kill $PID
  fi
  echo "Packet capture completed."
  echo "Output file: $DUMP_FILE"
}

# Check if interface is valid
if ! /sbin/ethtool "$INTERFACE" | grep -q "Link detected: yes"; then
    echo "Network interface not found or not online."
    usage
    exit 1
fi

# Check if duration is valid
if [ $DURATION -lt 0 ]; then
    echo "Error: Duration cannot be negative. Set to '0' for indefinite."
    usage
    exit 1
fi

# Check if running as root
if [ "$(id -u)" -ne "0" ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Check if tcpdump is installed
if ! command -v tcpdump &> /dev/null; then
    echo "tcpdump not found. Install tcpdump to use this script - 'sudo apt-get install tcpdump'"
    exit 1
fi

# Create output directory if it doesn't exist
if [ ! -d "$OUTPUT_DIR" ]; then
  mkdir -p "$OUTPUT_DIR"
fi

start_capture
