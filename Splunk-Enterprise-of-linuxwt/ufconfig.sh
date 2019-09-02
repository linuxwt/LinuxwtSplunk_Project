#!/bin/bash

[ -f /usr/bin/expect ] || yum -y install expect
/opt/splunkforwarder/bin/splunk enable boot-start -user root
single=$(cat ip.txt | grep -w sg | awk '{print $1}')
/usr/bin/expect << EOF
set timeout 200
spawn /opt/splunkforwarder/bin/splunk add forward-server ${single}:9997
expect "username"
send "admin\r"
expect "Password"
send "admin123\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn /opt/splunkforwarder/bin/splunk set deploy-poll ${single}:8089
set timeout 200
expect eof
exit
EOF


