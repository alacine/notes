## Install FastDFS Without Root Privilege

非 root 用户搭建 FastDFS 的过程

使用到的源码包以及版本信息如下(可以在 release 页面直接下载，也可以 clone 到本地，
然后 checkout 到对应版本号的 tag，然后开始做后面的步骤)

| 源码包                                                                       | 版本   | 描述                                   | 服务器依赖软件包                |
|------------------------------------------------------------------------------|--------|----------------------------------------|---------------------------------|
| [libfastcommon](https://github.com/happyfish100/fastdfs)                     | 1.0.48 | fastdfs 及 fastdfs-nginx-module 的依赖 | gcc-c++, perl                   |
| [fastdfs](https://github.com/happyfish100/libfastcommon)                     | 6.07   | fastdfs 本体                           | gcc-c++, perl                   |
| [fastdfs-nginx-module](https://github.com/happyfish100/fastdfs-nginx-module) | 1.22   | nginx fastdfs 模块                     | gcc-c++                         |
| [nginx](http://nginx.org/en/download.html)                                   | 1.18.0 |                                        | gcc-c++, zlib-devel, pcre-devel |

如果按照本文的方式进行安装，那么在修改完源码中的内容后，可以使用这里提供一个安
装的脚本 [fastdfs_deploy.sh](../script/fastdfs_deploy.sh)，请根据你在源码中修改
的内容自行修改脚本中对应的内容。同时希望能够尽量完整阅读，以便你知道脚本中为你
做了哪些操作。



目录
1. fastdfs Makefile 及 安装脚本修改
2. libfastcommon 编译安装
3. fastdfs 编译安装
4. nginx 编译安装
5. 集群搭建
6. 其他说明

### fastdfs Makefile 及 安装脚本修改

如果你是在 release 上下载的源码包，建议在解压后的路径里面`git init .`方便在后续
对比改动

由于需要重新指定安装路径，那么编译过程中使用的`INCLUDE_PATH`和`LIBRARY_PATH`，
这里建议在本地修改好之后再打包上传到服务器。 以下是需要修改的文件
```
client/Makefile.in
client/test/Makefile.in
common/Makefile
make.sh
storage/Makefile.in
tracker/Makefile.in
```

以下是具体每个文件的变更内容，`-`表示原来的内容，`+`表示变更后的内容
* client/Makefile.in
```
-INC_PATH = -I../common -I../tracker -I/usr/include/fastcommon
+INC_PATH = -I../common -I../tracker -I/app/fastdfs/target/usr/include
```
* client/test/Makefile.in
```
-INC_PATH = -I/usr/include/fastcommon -I/usr/include/fastdfs \
-           -I/usr/local/include/fastcommon -I/usr/local/include/fastdfs
+INC_PATH = -I/app/fastdfs/target/usr/include/fastcommon -I/app/fastdfs/target/usr/include/fastdfs \
+           -I/app/fastdfs/target/usr/local/include/fastcommon -I/app/fastdfs/target/usr/local/include/fastdfs
```
* common/Makefile
```
-INC_PATH = -I/usr/local/include
-LIB_PATH = -L/usr/local/lib
-TARGET_PATH = /usr/local/bin
+INC_PATH = -I/usr/local/include -I/app/fastdfs/target/usr/include
+LIB_PATH = -L/usr/local/lib -L /app/fastdfs/target/usr/lib
+TARGET_PATH = /app/fastdfs/target/usr/local/bin
```
* make.sh (大致在 38、164、165 行)
```
-LIBS=''
+LIBS="-L/app/fastdfs/target/usr/lib64 $LIBS"

-      if [ ! -d /etc/fdfs ]; then
-        mkdir -p /etc/fdfs
+      if [ ! -d $TARGET_CONF_PATH/etc/fdfs ]; then
+        mkdir -p $TARGET_CONF_PATH/etc/fdfs
```
* storage/Makefile.in
```
-INC_PATH = -I. -Itrunk_mgr -I../common -I../tracker -I../client -Ifdht_client -I/usr/include/fastcommon
+INC_PATH = -I. -Itrunk_mgr -I../common -I../tracker -I../client -Ifdht_client -I/app/fastdfs/target/usr/include
```
* tracker/Makefile.in
```
-INC_PATH = -I../common -I/usr/local/include
+INC_PATH = -I../common -I/usr/local/include -I/app/fastdfs/target/usr/include
```

### libfastcommon 编译安装

首先将 libfastcommon 源码包上传至服务器某一目录，这里用 /app/fastdfs 这个目录，
后续也会使用该目录，如果指定了其他目录，后续出现该目录的地方请自行变更。

解压并进入解压后的目录，在执行编译安装的命令前，首先定义以下变量，用来指定安装的
位置（默认情况下，libfastcommon 的编译安装过程会吧后续 fastdfs 需要的头文件放到
`/usr/include`、`/usr/local/include`，编译产生的动态链接库文件放到`/usr/lib/`或
`/usr/lib64`，默认情况下这些目录普通用户没有权限）。
```bash
export DESTDIR=/app/fastdfs/target
```

编译并安装
```bash
./make.sh clean && ./make.sh
./make.sh install
```

### fastdfs 编译安装

这里同样需要使用到前面设定的`DESTDIR`再进行编译安装
```bash
./make.sh clean && ./make.sh
./make.sh install
```

生成配置文件（有的教程中可能会教你进入配置文件目录，然后拷贝一份样例文件并去掉后
缀`.sample`，其实在源码的`INSTALL`文档中已经说明了可以使用自带的脚本创建，该脚本
会一次生成所有配置文件，**如果已经存在，则保留原有配置文件，因此不用担心会覆盖原
有配置**）

接下来需要创建并且修改配置文件，下面的目录其实不一定全部用到，为了方便就全部创建
出来了。
首先创建目录
```bash
mkdir /app/fastdfs/fdfa
mkdir /app/fastdfs/fdfa/client
mkdir /app/fastdfs/fdfa/tracker
mkdir /app/fastdfs/fdfa/storage
mkdir /app/fastdfs/fdfa/file
mkdir /app/fastdfs/fdfa/storage-data
```

修改如下配置文件，如果单机部署，请全部修改，如果是部署集群，那么请根据部署情况自
主修改对应的配置
```
tracker.conf  # tracker 配置
storage.conf  # storage 配置
client.conf   # client 配置，这个用于后续启动后的测试
```

tracker.conf
```
port = 22122  # tracker 的端口
base_path = /app/fastdfs/fdfa/tracker  # 数据和日至的存储路径
store_group = group1  # 所属组
http.server_port = 8100  # 这个端口需要和后续的 nginx 端口保持一致
```

storage.conf
```
port = 23000  # storage 的端口
base_path = /app/fastdfs/fdfa/storage  # 数据和日至的存储路径
store_path0 = /app/fastdfs/fdfa/storage-data  # 当不存在时，默认和 base_path 保持一致，从主注释中可以看到，fastdfs 作者并不建议这么做
group_name = group1  # 所属组
http.server_port = 8100  # 这个端口需要和后续的 nginx 端口保持一致
tracker_server = xx.xx.xx.xx:22122  # 前面 tracker 的 ip 及端口，可以有多个，写法请看里面的注释
```

client.conf
```
base_path = /app/fastdfs/fdfa/client  # 日至存储路径
tracker_server = xx.xx.xx.xx:22122  # 前面 tracker 的 ip 以及端口，可以有多个，写法参照里面的注释
```

声明 C 运行时的动态链接库目录位置，如果不做这一步，在后续启动时你会遇到找不到 
libfastcommon.so 的问题
```bash
export LD_LIBRARY_PATH=/app/fastdfs/target/usr/lib64
```

启动 tracker 和 storage
```bash
./fdfs_storaged /app/fastdfs/target/etc/fdfs/storage.conf start
./fdfs_trackerd /app/fastdfs/target/etc/fdfs/tracker.conf start
```

如果你在启动 storage 时遇到了以下错误，可以尝试再执行一次上面的 storage 启动命令
```
[2021-02-26 11:04:10] ERROR - file: storage_func.c, line: 718, chown "/app/fastdfs/fdfa/storage/data" fail, errno: 1, error info: Operation not permitted
```

测试是否能够使用（这里先传一张图片到服务器上用作测试）
```bash
./fdfs_test /app/fastdfs/target/etc/fdfs/client.conf upload /app/playground/a.png
```
如果成功，那么终端将会输出一系列该文件的信息，记下其中的 example file url，用来
后面的测试 nginx 是否搭建成功


### nginx 编译安装

需要先修改 fastdfs-nginx-module 源码中`src/config`的`FDFS_MOD_CONF_FILENAME` (大致在第 10、17 行)
```
-    CFLAGS="$CFLAGS -D_FILE_OFFSET_BITS=64 -DFDFS_OUTPUT_CHUNK_SIZE='256*1024' -DFDFS_MOD_CONF_FILENAME='\"/etc/fdfs/mod_fastdfs.conf\"'"
+    CFLAGS="$CFLAGS -D_FILE_OFFSET_BITS=64 -DFDFS_OUTPUT_CHUNK_SIZE='256*1024' -DFDFS_MOD_CONF_FILENAME='\"/app/fastdfs/target/etc/fdfs/mod_fastdfs.conf\"'"
-    CFLAGS="$CFLAGS -D_FILE_OFFSET_BITS=64 -DFDFS_OUTPUT_CHUNK_SIZE='256*1024' -DFDFS_MOD_CONF_FILENAME='\"/etc/fdfs/mod_fastdfs.conf\"'"
+    CFLAGS="$CFLAGS -D_FILE_OFFSET_BITS=64 -DFDFS_OUTPUT_CHUNK_SIZE='256*1024' -DFDFS_MOD_CONF_FILENAME='\"/app/fastdfs/target/etc/fdfs/mod_fastdfs.conf\"'"
```

编译并安装：
声明以下变量，用于编译安装，**同时取消掉原来的`DESTDIR`的声明，因为这个变量同时
会影响 nginx 的安装路径**
```bash
unset DESTDIR
export C_INCLUDE_PATH=/app/fastdfs/target/usr/include
export LIBRARY_PATH=/app/fastdfs/target/usr/lib64
```

nginx 源码包解压后进入 nginx 的目录，prefix 参数声明 nginx 的安装路径，如果上面
提到的`DESTDIR`没有`unset`， 那么实际完整的安装路径是`${DESTDIR}/$prefix`
```bash
./configure --prefix=/app/nginx --add-module=/app/fastdfs/fastdfs-nginx-module-1.22/src
make
make install
```

把 fastdfs-nginx-module 新的配置文件复制到之前"修改 FDFS_MOD_CONF_FILENAME" 的位置
```bash
cp src/mod_fastdfs.conf /app/fastdfs/target/etc/fdfs/
```

并修改以下配置`/app/fastdfs/target/etc/fdfs/mod_fastdfs.conf`，请根据实际情况按
需修改
```
storage_server_port = 23000  # 前面配置的 storage.conf 中的 port
store_path0 = /app/fastdfs/fdfa/storage-data  # storage 的存储路径
tracker_server = xx.xx.xx.xx:22122  # tracker 的地址
url_have_group_name = true  # url 中是否包含组名
group_name = group1  # 组名
```

进入到 nginx 的安装目录（前面编译时 prefix 参数），修改 nginx 的配置`conf/nginx.conf`
```
# http -> server -> listen
    listen 8100
# http -> server -> location
    location / {
        #root html;
        #index index.html index.htm;
        ngx_fastdfs_module;
    }
```

切换到 nginx 的 sbin 路径检测一次配置文件看看是否有语法错误
```bash
./nginx -t -c /app/nginx/conf/nginx.conf
```
如果没有问题，那么就可以重新启动了（由于是 nginx 是添加新模块编译安装的，因此
还要确保 fastdfs-nginx-module 的运行时动态链接库也要有，即之前配置的环境变量
`LD_LIBRARY_PATH`，如果中途有推出登陆过服务器，记得重新设置一次）

查看效果

之前上传过一张图片，有一个 url，通过浏览器访问 nginx 端口 + url，如果能看到图片，
那么就算是完成了。

### 集群搭建

根据部署情况，修改 tracker.conf 和 storage.conf 中的 ip 相关的配置。需要注意的是，
分组的概念是对于 storage 而言的，**因此每一个 storage 都需要在自己的 storage.conf 
中指定所有的 tracker**

### 其他说明

1. **不要使用`kill -9`来强杀进程，否则可能导致 binlog 数据丢失！**（binlog 不包
含文件数据，之包含文件名等元信息，用于后台的同步，storage 会记录向同 group 内其
他 storage 同步的进度，一边重启之后能够接上次的进度继续同步，进度以时间戳的方式
进行记录，因此最好保证集群内部所有 server 的时钟不要相差超过一分钟）

退出
```bash
killall fdfs_trackerd
killall fdfs_storaged
```
或
```bash
/app/fastdfs/targe/usr/bin/fdfs_trackerd /app/fastdfs/target/etc/fdfs/tracker.conf stop
/app/fastdfs/targe/usr/bin/fdfs_storaged /app/fastdfs/target/etc/fdfs/storage.conf stop
```

重启
```bash
/app/fastdfs/targe/usr/bin/fdfs_trackerd /app/fastdfs/target/etc/fdfs/tracker.conf restart
/app/fastdfs/targe/usr/bin/fdfs_storaged /app/fastdfs/target/etc/fdfs/storage.conf restart
```

2. 分布式集群部署后，存储空间如何计算？

一个 group 内包含多个 storage 机器，组内数据互为备份，存储空间以组内最小的 storage 
为准，例如 group1 中两台服务器的存储分别为 100G、200G，group2 中两台服务器的存储
分别为 200G、200G，那么总的存储空间就是 `min(100G, 200G) + min(200G, 200G) = 300G`。
因此也建议同一个 group 内的 storage 配置尽量相同，减少浪费。

3. 上传文件后，存储的 group 具体怎么选择？

在 tracker.conf 中 store_lookup 参数的注释，可以看到有三种选择模式，默认选择是 load balance
* round robin: 轮询 group
* specify group: 指定某一个 group
* load balance: 自动选择剩余空间最大的 group
