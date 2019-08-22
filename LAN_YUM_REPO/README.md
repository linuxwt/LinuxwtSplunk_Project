# LAN_YUM_REPO 
执行local.sh建立私有仓库  
createrepo.tar.gz是createrepo工具的相关包   
rpm.tar.gz是docker18.03相关包   
nginx.tar.gz是nginx1.12相关包   
yumdownload.tar.gz是yumdownload工具的相关包   
docker-compose-Linux-x86_64为下载下来的docker-compose文件，用来安装docker-compose，可以使用脚本compose.sh来配置   
replenish是补充一些常用的工具包，需要将里面的包放入yum仓库  
yumdownload工具使用方法举例：  
yumdownloader --resolve --destdir=rpmdir docker \  
依赖包1 \  
... \  
依赖包n   





