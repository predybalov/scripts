# List IPs available in a specific subnet

#! /usr/bin/env bash

if [ -z $1 ]; then

  echo "Please enter subnet prefix"
  echo "Sample usage: ./check_ip 192.168.1"
  
else
  file=${HOME}/ips.tmp
  
  for i in {1..254}
  do
    ping -c 1 ${1}.$i |grep "64 bytes" |awk '{print $4}' |sed 's/://' >> $file &
  done

  sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n $file
  rm $file
  
fi
