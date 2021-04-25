#!/bin/bash

# install fastdfs without root
# 这个是 fastdfs 安装部署的脚本，请在使用前阅读 https://github.com/alacine/notes/blob/master/fastdfs.md
# 这个脚本默认假设有两台 tracker，如果不是，你需要自行做修改

#set -x

base_path="/app/fastdfs/fdfa"
cd ${base_path}
if [ ! -d ${base_path} ]; then
    mkdir -pv ${base_path}
fi
base_path=$(echo ${base_path} | sed 's/\//\\\//g')

tracker_port=22122
tracker_addr[0]="xx.xx.xx.xx:${tracker_port}"
tracker_addr[1]="xx.xx.xx.xx:${tracker_port}"
tracker_base_path="${base_path}\/tracker"

storage_port=23000
storage_base_path="${base_path}\/storage"
storage_store_path0="${base_path}\/storage-data"

client_base_path="${base_path}\/client"

mod_fastdfs_url_have_group_name="true"

nginx_port=8100

if [[ $# -eq 0 ]]; then
    echo "部署 group1 的 storage, 且同时为 tracker."
    echo
    echo "  ./fastdfs_deploy.sh group1 tracker"
    echo
    echo "部署 group2 的 storage, 非 tracker"
    echo
    echo "  ./fastdfs_deploy.sh group2"
    exit 1
fi

group=$1
tracker=$2

echo "========================"
echo "get fastdfs.tar ..."
echo "========================"
cd /app
if [ ! -e fastdfs.tar ]; then
    echo "download fastdfs.tar"
    wget http://192.168.56.1:8000/fastdfs.tar
fi

tar -xf fastdfs.tar
export DESTDIR="/app/fastdfs/target"

echo "========================"
echo "build and install libfastcommon"
echo "========================"
cd /app/fastdfs/libfastcommon-1.0.48
./make.sh clean && ./make.sh
./make.sh install


echo "========================"
echo "build and install fastdfs"
echo "========================"
cd /app/fastdfs/fastdfs-6.07
./make.sh clean && ./make.sh
./make.sh install
./setup.sh /app/fastdfs/target/etc/fdfs


echo "========================"
echo "create data and log directory"
echo "========================"
mkdir -p /app/fastdfs/fdfs/client
mkdir -p /app/fastdfs/fdfs/tracker
mkdir -p /app/fastdfs/fdfs/storage
mkdir -p /app/fastdfs/fdfs/file
mkdir -p /app/fastdfs/fdfs/storage-data

echo "========================"
echo "create data and log directory"
echo "========================"
cd /app/fastdfs/target/fdfs
sed -i "s/^\(port\).*$/\1 = ${storage_port}/g" storage.conf
sed -i "0,/^tracker_server/s/\(tracker_server\).*$/\1 = ${tracker_addr[0]}/g" storage.conf
sed -i "s/^\(tracker_server\).*192.*$\1 = ${tracker_addr[1]}/g" storage.conf
sed -i "s/^\(base_path\).*$/\1 = ${storage_base_path}/g" storage.conf
sed -i "s/^\(group_name\).*$/\1 = ${group}/g" storage.conf
sed -i "s/^\(store_path0\).*$/\1 = ${storage_store_path0}/g" storage.conf
sed -i "s/^\(http.server_port\).*$/\1 = ${nginx_port}/g" storage.conf
grep "^port" storage.conf
grep "^tracker_server" storage.conf
grep "^base_path" storage.conf
grep "^grep_name" storage.conf
grep "^store_path0" storage.conf
grep "^http.server_port" storage.conf
grep "^group_name" storage.conf

echo "========================"
echo "edit tracker.conf"
echo "========================"
sed -i "s/^\(port\).*$/\1 = ${tracker_port}/g" tracker.conf
sed -i "s/^\(base_path\).*$/\1 = ${tracker_base_path}/g" tracker.conf
sed -i "s/^\(store_group\).*$/\1 = ${group}/g" tracker.conf
sed -i "s/^\(http.server_port\).*$/\1 = ${nginx_port}/g" tracker.conf
grep "^port" tracker.conf
grep "^base_path" tracker.conf
grep "^store_group" tracker.conf
grep "^http.server_port" tracker.conf

echo "========================"
echo "edit client.conf"
echo "========================"
sed -i "s/^\(base_path\).*$/\1 = ${client_base_path}/g" client.conf
sed -i "0,/^tracker_server/s/^\(tracker_server\).*$/\1 = ${tracker_addr[0]}/g" client.conf
sed -i "s/^\(tracker_server\).*192.*$/\1 = ${tracker_addr[1]}/g" client.conf
grep "^base_path" client.conf
grep "^tracker_server" client.conf

echo "========================"
echo "build and install nginx"
echo "========================"
unset DESTDIR
export C_INCLUDE_PATH=/app/fastdfs/target/usr/include
export LIBRARY_PATH=/app/fastdfs/target/usr/lib64
cd /app/fastdfs
tar -zxf nginx-1.18.0.tar.gz
cd /app/fastdfs/nginx-1.18.0/
./configure --prefix=/app/nginx --add-module=/app/fastdfs/fastdfs-nginx-module-1.22/src
make && make install
cp /app/fastdfs/fastdfs-nginx-module-1.22/src/mod_fastdfs.conf /app/fastdfs/target/etc/fdfs/

echo "========================"
echo "edit mod_fastdfs.conf"
echo "========================"
cd /app/fastdfs/target/etc/fdfs/
sed -i "s/^\(storage_server_port\).*$/\1 = ${storage_port}/g" mod_fastdfs.conf
sed -i "s/^\(store_path0\).*$/\1 = ${storage_store_path0}/g" mod_fastdfs.conf
sed -i "s/^\(url_have_grep_name\).*$/\1 = ${mod_fastdfs_url_have_group_name}/g" mod_fastdfs.conf
sed -i "s/^\(group_name\).*$/\1 = ${group}/g" mod_fastdfs.conf
sed -i "/^tracker_server/a tracker_server = ${tracker_addr[1]}" mod_fastdfs.conf
grep "^storage_server_port" mod_fastdfs.conf
grep "^store_path0" mod_fastdfs.conf
grep "^url_have_grep_name" mod_fastdfs.conf
grep "^tracker_server" mod_fastdfs.conf

echo "========================"
echo "edit nginx.conf"
echo "========================"
cd /app/nginx/confg
sed -i "s/^\(\s*listen\s*\)[0-9]\+;/\1${nginx_port};/g" nginx.conf
sed -i "/^\s*location \//,/^\s*root/s/^\(\s*\)\(root.*\)$/\1#\2/g" nginx.conf
sed -i "/^\s*location \//,/^\s*index/s/^\(\s*\)\(index.*\)$/\1#\2/g" nginx.conf
sed -i "/^\s*location \//,/^\s*index/s/^\(\s*\)index\(.*\)$/\1ngx_fastdfs_module;/g" nginx.conf

export LD_LIBRARY_PATH=/app/fastdfs/target/usr/lib64
cnt=$(grep LD_LIBRARY_PATH ~/.bash_profile | wc -l)
if [ $$cnt -eq 0 ]; then
    echo "exprot LD_LIBRARY_PATH=/app/fastdfs/target/usr/lib64" >> ~/.bash_profile
fi
echo "========================"
echo "start fdfs tracker"
echo "========================"
if [[ $tracker = "tracker" ]]; then
    /app/fastdfs/target/usr/bin/fdfs_trackerd /app/fastdfs/target/etc/fdfs/tracker.conf start
fi

echo "========================"
echo "start fdfs storage"
echo "========================"
/app/fastdfs/target/usr/bin/fdfs_storaged /app/fastdfs/target/etc/fdfs/storage.conf start
if [[ $? -ne 0 ]]; then
    /app/fastdfs/target/usr/bin/fdfs_storaged /app/fastdfs/target/etc/fdfs/storage.conf start
fi

echo "========================"
echo "start nginx"
echo "========================"
cd /app/nginx/sbin
./nginx
/app/fastdfs/target/usr/bin/fdfs_monitor /app/fastdfs/target/etc/fdfs/client.conf
cd /app
