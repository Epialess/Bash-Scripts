#!/bin/bash

# A script that pings each IP address in a list of IPs in the ip_list file

# Check if the ip_list file exists
if [ ! -f ip_list ]; then
    echo "The file 'ip_list' does not exist."
    exit 1
fi

while IFS= read -r ip
do
    echo "Pinging $ip..."
    ping -c 4 "$ip"
    echo "================================="
done < ip_list