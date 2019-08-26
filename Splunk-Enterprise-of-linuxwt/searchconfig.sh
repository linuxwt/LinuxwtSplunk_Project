#!/bin/bash

search=$(cat ip.txt | grep -w in | awk '{print $1}')
/opt/splunk/bin/splunk add search-server https://${search}:8089 -auth admin:admin123 -remoteUsername admin -remotePassword admin123
