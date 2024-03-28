#!/bin/bash

# A shell script that retrieves data center information, the IP owner, city, 
# and country from a domain name using dig and ipinfo.io API.

# Prerequisites: dig
#               jq
#               ipinfo.io API token

# Check for domain argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <DOMAIN>"
  exit 1
fi

DOMAIN=$1

# Check if dig is installed
if ! command -v dig &> /dev/null; then
    echo "dig not found. Install dig to use this script - 'sudo apt-get install dig'"
    exit 1
fi

# Check if dig is installed
if ! command -v jq &> /dev/null; then
    echo "jq not found. Install jq to use this script - 'sudo apt-get install jq'"
    exit 1
fi

# Use dig to get the IP address of the domain
IP_ADDRESS=$(dig +short $DOMAIN | tail -n1)
if [ -z "$IP_ADDRESS" ]; then
  echo "Failed to obtain IP address for $DOMAIN"
  exit 1
fi
echo "IP Address: $IP_ADDRESS"

API_TOKEN="" # Enter your token here
API_RESPONSE=$(curl -s "http://ipinfo.io/$IP_ADDRESS?token=$API_TOKEN")

# Using jq to parse the JSON response
COUNTRY=$(echo "$API_RESPONSE" | jq -r '.country')
CITY=$(echo "$API_RESPONSE" | jq -r '.city')
ORG_NAME=$(echo "$API_RESPONSE" | jq -r '.org')
NET_RANGE=$(echo "$API_RESPONSE" | jq -r '.ip')
ORIGIN_AS=$(echo "$API_RESPONSE" | jq -r '.asn.asn')

echo "Country: $COUNTRY"
echo "City: $CITY"
echo "Organization: $ORG_NAME"
echo "IP Range from API: $NET_RANGE"
echo "ASN: $ORIGIN_AS"