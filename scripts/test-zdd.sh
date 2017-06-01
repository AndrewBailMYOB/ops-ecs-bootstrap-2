#!/bin/bash

endpoint="http://google.com"
logfile="zdd.log"
timeout=.3

while :; do
    status=$(curl -s -o /dev/null -w "%{http_code}" $endpoint)
    echo -e "$endpoint\t$status"
    sleep $timeout
done | tee -a $logfile
