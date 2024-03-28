#!/bin/bash

# A shell script that retrieves data center information, the IP owner, city, 
# and country from a domain name using dig and whois.

# Prerequisites: dig
#               whois

# Check for domain argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <DOMAIN>"
  exit 1
fi

# Check if dig is installed
if ! command -v dig &> /dev/null; then
    echo "dig not found. Install dig to use this script - 'sudo apt-get install dig'"
    exit 1
fi

# Check if whois is installed
if ! command -v whois &> /dev/null; then
    echo "whois not found. Install whois to use this script - 'sudo apt-get install whois'"
    exit 1
fi

DOMAIN=$1

# Use dig to get the IP address of the domain
IP_ADDRESS=$(dig +short $DOMAIN | tail -n1)

if [ -z "$IP_ADDRESS" ]; then
  echo "Failed to obtain IP address for $DOMAIN"
  exit 1
fi
echo -e "IP Address: \t$IP_ADDRESS"

# Get owner and network information from IP
OWNER_INFO=$(whois $IP_ADDRESS)

ORG_NAME=$(echo "$OWNER_INFO" | grep -E 'OrgName' | head -1)
ADDRESS=$(echo "$OWNER_INFO" | grep -E 'Address' | head -1)
CITY=$(echo "$OWNER_INFO" | grep -E 'City' | head -1)
STATE=$(echo "$OWNER_INFO" | grep -E 'StateProv' | head -1)
COUNTRY=$(echo "$OWNER_INFO" | grep -E 'Country' | head -1)

NET_RANGE=$(echo "$OWNER_INFO" | grep -E 'NetRange|inetnum' | head -1)
ORIGIN_AS=$(echo "$OWNER_INFO" | grep -E 'OriginAS|origin' | head -1)

echo "$ORG_NAME"
echo "$ADDRESS"
echo "$CITY"
echo "$STATE"
echo "$COUNTRY"
echo "$NET_RANGE"
echo "$ORIGIN_AS"