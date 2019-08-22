#!/bin/bash

toolinstall () {
[[ -f /usr/bin/expect && -f /usr/bin/rz ]] || yum -y install lrzsz expect 
/usr/bin/expect << EOF
set timeout 200
spawn ssh ${ip} -o StrictHostKeyChecking=no "yum -y install lrzsz expect"
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF
}

remotesh () {
/usr/bin/expect << EOF
set timeout 200
spawn scp splunk_install.sh splunkforwarder-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz ${ip}:/root
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${ip} -o StrictHostKeyChecking=no /root/splunk_install.sh
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF
}

c=$(basename $(ls -l /etc/sysconfig/network-scripts/* | grep ifcfg | grep -v lo | awk -F ' ' '{print $9}'))
netcard=${c//ifcfg-/}
local_ip=$(ip addr | grep ${netcard} | grep inet | awk -F ' ' '{print $2}' | awk -F '/' '{print $1}')
while read ip passwd sf
do
[ $ip != "${local_ip}" ] && { toolinstall;remotesh; } || $(pwd)/splunk_install.sh
done < ip.txt
