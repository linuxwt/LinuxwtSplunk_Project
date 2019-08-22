#!/bin/bash

ntpserver="10.8.8.2"
prog=$(systemctl status firewalld | grep Active | grep running | wc -l)
[ ${prog} -eq 1 ] && systemctl stop firewalld && systemctl disable firewalld
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
setenforce 0
mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/CentOS* /etc/yum.repos.d/bak
mv /root/local.repo /etc/yum.repos.d
yum makecache
yum -y install ntpdate
ntpdate ${ntpserver} >>/dev/null 2>&1
