#!/bin/bash

[ -f /usr/bin/expect ] || yum -y install expect
/opt/splunk/bin/splunk enable boot-start -user root
/usr/bin/expect << EOF
set timeout 200
spawn /opt/splunk/bin/splunk enable listen 9997
expect "username"
send "admin\r"
expect "Password"
send "admin123\r"
set timeout 200
expect eof
exit
EOF
