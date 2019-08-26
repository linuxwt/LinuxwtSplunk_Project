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

essh () {
/usr/bin/expect << EOF
set timeout 200
spawn scp -o StrictHostKeyChecking=no  splunk_install.sh indexconfig.sh splunk-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz ${ip}:/root
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

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${ip} -o StrictHostKeyChecking=no /root/indexconfig.sh
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF
}

ufsh () {
/usr/bin/expect << EOF
set timeout 200
spawn scp -o StrictHostKeyChecking=no splunkforwarder_install.sh ufconfig.sh ip.txt splunkforwarder-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz ${ip}:/root
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${ip} -o StrictHostKeyChecking=no /root/splunkforwarder_install.sh
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${ip} -o StrictHostKeyChecking=no /root/ufconfig.sh
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
    if [ $ip == "${local_ip}" ];then
        $(pwd)/splunk_install.sh
    else
        if [ ${sf} == "in" ];then
            { toolinstall;essh; }
        else
            { toolinstall;ufsh; }
        fi
    fi
done < ip.txt
