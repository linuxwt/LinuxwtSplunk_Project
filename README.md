# 该仓库分支代码使用的系统环境  
最新安装的最小化版本的centos7.6，没有做任何配置和装任何软件，该分支代码主要是用来一键搭建splunk平台

# 脚本使用说明  
1、首先克隆仓库代码到本地  
2、将代码上传到search(10.8.8.100)所在的服务器  
3、根据部署需要修改文件Splunk-Enterprise-of-linuxwt/ip.txt，里面的三列分别表示ip、root密码、splunk组件名 
这里假设需要装search(10.8.8.100)、index(10.8.8.101)、uf(10.8.8.102)各一台服务器账号密码均为  
root/sinobridge  
4、根据需要修改文件envconfig.sh和yumconfig.sh里的定义时间服务器的变量ntpserver的值     
5、在仓库根目录执行脚本 bash envconfig.sh  

# 脚本完成的功能  
1、在search建立yum私有仓库并共享给局域网  
2、将index、uf上的yum源更换成search上的私有仓库  
3、关闭了search、index、uf上的firewalld、selinux  
4、安装search、index、uf  
5、配置index(启用索引接收器)、uf(设置数据输入到索引接收器、设置部署客户端)、search(激活部署服务端)  
6、配置了search index uf的管理员账号密码:admin/admin  
