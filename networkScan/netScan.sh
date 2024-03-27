#!/bin/bash

# A script to discover network devices using nmap

# Prerequisite: nmap

# The network range to scan
NETWORK_RANGE="192.168.1.0/24"

echo "Starting network discovery for $NETWORK_RANGE"
echo "============================================="

# Check if nmap is installed
if ! command -v nmap &> /dev/null; then
    echo "nmap not found. Install nmap to use this script - 'sudo apt-get upgrade nmap'"
    exit 1
fi

# nmap -sn $NETWORK_RANGE

echo "Performing host discovery using nmap ..."
nmap -sn -n -PR $NETWORK_RANGE -oG - | awk '/Up$/{print $2, $3}'

echo "============================================="
echo "Network discovery complete."

