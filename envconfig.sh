#!/bin/bash

yumconfig () {
/usr/bin/expect << EOF
set timeout 200
spawn scp  -o StrictHostKeyChecking=no $(pwd)/yumconfig.sh /etc/yum.repos.d/local.repo ${ip}:/root
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF

/usr/bin/expect << EOF
set timeout 200
spawn ssh ${ip} -o StrictHostKeyChecking=no /root/yumconfig.sh
expect "password"
send "${passwd}\r"
set timeout 200
expect eof
exit
EOF
}

ntpserver="10.8.8.2"
$(pwd)/LAN_YUM_REPO/local.sh  
yum -y install expect ntpdate
[ -f /usr/bin/expect ] || exit -1
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
setenforce 0
ntpdate ${ntpserver} >>/dev/null 2>&1
 
c=$(basename $(ls -l /etc/sysconfig/network-scripts/* | grep ifcfg | grep -v lo | awk -F ' ' '{print $9}'))
netcard=${c//ifcfg-/}
local_ip=$(ip addr | grep ${netcard} | grep inet | awk -F ' ' '{print $2}' | awk -F '/' '{print $1}')
while read ip passwd sf
do
[ $ip != "${local_ip}" ] && yumconfig
done < $(pwd)/Splunk-Enterprise-of-linuxwt/ip.txt

[ $? -eq 0 ] && ( cd $(pwd)/Splunk-Enterprise-of-linuxwt && bash serial_installsplunk.sh ) || exit -1

