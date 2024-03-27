#!/bin/bash

# A script that generates ip addresses in ip_list

start=1
end=10

for i in $(seq $start $end)
do
   echo "192.168.1.$i"
   echo "1.1.1.1"
   echo "8.8.8.8"
done > ip_list