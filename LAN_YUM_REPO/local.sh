#!/bin/bash

tar zvxf $(pwd)/LAN_YUM_REPO/createrepo.tar.gz -C $(pwd)/LAN_YUM_REPO
tar zvxf $(pwd)/LAN_YUM_REPO/nginx.tar.gz -C $(pwd)/LAN_YUM_REPO
tar zvxf $(pwd)/LAN_YUM_REPO/rpm.tar.gz -C $(pwd)/LAN_YUM_REPO

create_repo () {
cd $(pwd)/LAN_YUM_REPO/createrepodir
yum -y localinstall *
}

nginxrepo () {
cd $(pwd)/LAN_YUM_REPO/nginxdir
yum -y localinstall *
}

create_repo
cd -
nginxrepo
cd -
nginx


mkdir -p /usr/share/nginx/html/myshare
createrepo /usr/share/nginx/html/myshare
mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/CentOS* /etc/yum.repos.d/bak

netcard=$(basename $(ls -la /etc/sysconfig/network-scripts/ifcfg* | grep -v lo | awk -F ' ' '{print $9}')) 
Netcard=${netcard/ifcfg-/}
ip=$(ip addr | grep ${Netcard} | grep inet | awk -F ' ' '{print $2}' | awk -F '/' '{print $1}')
cat <<EOF>> /etc/yum.repos.d/local.repo
[local]
name=local
baseurl=http://${ip}/myshare
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF


mv -f $(pwd)/LAN_YUM_REPO/rpmdir/* /usr/share/nginx/html/myshare
mv -f $(pwd)/LAN_YUM_REPO/nginxdir/* /usr/share/nginx/html/myshare
cp  $(pwd)/LAN_YUM_REPO/replenish/* /usr/share/nginx/html/myshare
createrepo /usr/share/nginx/html/myshare 
yum makecache
