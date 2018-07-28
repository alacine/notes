## 常用命令

### 挂载
* mount [-t 文件系统] [-o 特殊选项] 设备文件名 挂载点
> 光盘的默认设备名称为```sr0```
* umount 设备文件名或挂载点

* fdisk -l (查看系统当前已经识别的硬盘)  
```mount -t vfat /dev/sdb1 /mnt/usb/``` (挂载U盘，其中sdb1为U盘设备名)

### 压缩 打包
* zip
    - zip 压缩文件名 源文件
    - zip -r 压缩文件名 源目录
    - unzip 压缩文件 (解压缩)

* gz
    - gzip 源文件 (源文件消失)
    - gzip -c 源文件 > 压缩文件 (源文件保留)
    - gzip -r 目录 (压缩目录下的所有子文件，但是不能压缩目录)
    - gzip -d 压缩文件 (解压缩文件)
    - gunzip 压缩文件 (解压缩文件 -r)

* bz2
    - bzip2 源文件 (压缩为.bz2格式，不保留源文件)
    - bzip2 -k 源文件 (压缩之后保留源文件)
    - **bzip2 不能压缩目录**
    - bzip2 -d 压缩文件 (解压缩，-k保留压缩文件)
    - bunzip2 压缩文件 (解压缩，-k保留压缩文件)

* tar
    - tar -cvf 打包文件名 源文件 (c打包，v显示过程，f指定打包后的文件名)
    - tar -xvf 打包文件名 (x解打包)
    - tar -zcvf 压缩包名.tar.gz 源文件 (z压缩为.tar.gz格式，多个源文件用空格隔开)
    - tar -zxvf 压缩包名.tar.gz (解压缩.tar.gz格式)
    - tar -jcvf 压缩包名.tar.bz2 源文件 (j压缩为.tar.bz2格式)
    - tar -jxvf 压缩包名.tar.bz2 (解压缩.tar.bz2格式)
    - tar -z(j)xvf 压缩报名.tar.gz(.bz2) -C 指定目录
    - tar -ztvf 压缩包名 (t查看压缩包中的内容)


### 多命令顺序执行

|多命令执行符|格式|作用|
|-----|------|-----|
|;| 命令1;命令2 | 多个命令顺序执行|
|&&|命令1&&命令2|1正确2才会执行，1错误2不执行|
|\|\||命令1\|\|命令2|1正确2不执行，1错误2执行|

### 特殊符号

* 管道符  
| (命令1|命令2)  
命令1的结果作为命令2的操作对象

* 通配符

|通配符|作用|
|----|---|
| ? |匹配任意一个字符|
| * |匹配任意内容|
| [] |匹配中括号中任意一个字符，例如[abc]，或者是a，或者是b，或者是c|
| [-] |匹配中括号中任意一个字符，-表示范围，例如[a-z]，代表匹配一个小写字母|
| [^] |逻辑非，匹配不是中括号中任意一个字符，-表示范围，例如[^0-9]，代表匹配一个不是数字的字符|

* bash中其他特殊符号  

|符号|作用|
|---|---|
|''|单引号，在引号中的特殊符号都没有特殊含义|
|""|双引号，在引号中的特殊符号没有特殊含义，但是“$”(调用变量值)、“`”(引用命令)、“\”(转义符)例外|
|``|反引号，反引号括起来的是系统命令，在bash中会先执行它。和$()作用一样，推荐使用$()|
|$()|同上|
|#|注释|
|$|调用变量的值|
|\\ |转义符|

### 网络
* ifconifg 查看与配置网络状态
* ifdown 网卡设备  
禁用该网卡设备
* ifup 网卡设备  
启用该网卡设备
* netstat 查询网络连接状态
    - -t: 列出TCP协议端口
    - -u: 列出UDP协议端口
    - -n: 不使用域名和服务名，而使用IP地址和端口号
    - -l: 仅列出在监听状态网络服务
    - -a: 列出所有的网络连接
    - -r: 列出路由表，功能和route命令一致

* route -n 查看路由列表(可以看到网关)
* route add default gw 192.168.1.1  
临时设定网关
* route del default gw 192.168.1.1  
删除网关

* nslookup 域名解析命令
    - nslookup [主机名或IP] (进行域名与IP地址解析)
    - $ nslookup  
     \> server 查看本机DNS服务器

* ping -c 次数(指定ping保的数量)
* telnet 域名或IP 端口 (远程管理与端口探测)
* traceroute 选项 IP或域名(路由跟踪，-n使用IP不使用域名)
* wget + 地址 (下载)
* tcpdump -i eth0 -nnX port 21 (抓包)
    - -i 指定网卡接口
    - -nn 将数据包中的域名与服务转为IP和端口
    - -X 以十六进制和ASCII码显示数据包内容
    - port 指定监听端口

* ssh 用户名@ip (远程管理指定服务器)
* scp [-r] 用户名@ip:文件路径 本地路径 (下载)
* scp [-r] 本地路径 用户名@ip:上传路径 (上传)


## 软件安装

### RPM

* 包全名：操作的包是没有安装的软件包时，使用包全名。而且要注意路径
* 包名：操作已经安装的软件包时，使用包名，是搜索```/var/lib/rpm```中的数据库

* rpm -ivh 包全名
    - -i (install) 安装
    - -v (verbose) 显示详细信息
    - -h (hash) 显示进度
    - --nodeps 不检测依赖性
* rpm -Uvh 包全名
    - -U (upgrade) 升级
    - --nodeps 
* rpm -e 包名
    - -e (erase) 卸载
    - --nodeps 
* rpm -q 包名
    - -q (query) 查询包是否安装
    - -qa (all) 查询所有安装的rpm包(不加包名)
* rpm -qi 包名
    - -i (information) 查询软件信息
    - -q (package) 查询未安装包信息(跟包全名)
* rpm -ql 包名 (查询包中文件安装位置)
    - -l (list) 列表
    - -p 查询未安装包信息
* rpm -qf 系统文件名
    - -f (file) 查询系统文件属于哪个软件包
* rpm -qR 包名 
    - -R (requires) 查询软件包的依赖性
    - -p 查询未安装的包的信息
* rpm -V 已安装包名
    - -V (verify) 校验指定RPM包中的文件
    - 校验内容中的8个信息的具体内容如下：
        * S 文件大小是否改变
        * M 文件类型或文件权限(rwx)是否改变
        * 5 文件MD5校验和是否改变(可以看成文件内容是否改变)
        * D 设备的主从代码是否改变
        * L 文件路径是否改变
        * U 文件属从(所有者)是否改变
        * G 文件属组是否改变
        * T 文件的修改时间是否改变
    - 文件类型
        * c (config) 配置文件
        * d (documentation) 普通文件
        * g (ghost file) “鬼”文件，很少见，就是该文件不应该被这个RPM包包含
        * L (license file) 授权文件
        * r (read me) 描述文件
* rpm2cpio 包全名 | cpio -idv .文件绝对路径 
    - -rpm2cpio 将rpm包转化为cpio格式的命令
    - -cpio 是一个标准工具，它用于创建软件档案文件和从档案文件中提取文件  
    cpio 选项 < [文件|设备]  
        * -i: copy-in 模式，还原
        * -d: 还原时自动新建目录
        * -v: 显示还原过程

### YUM

Yum 源文件```/etc/yum.repos.d/CentOS-Base.repo```
* [base] 容器名称，一定要放在[]中
* name 容器说明，可以随便写
* mirrorlist 镜像站点
* baseurl yum源服务器地址，默认是CentOS官方的yum源服务器
* enable 生效为1或者不写，为0不生效
* gpgcheck RPM的数字证书，1生效，0不生效
* gpgkey 数字证书的公钥保存位置。不用修改

常用yum命令
* yum list # 查询所有可用软件包列表
* yum search # 搜索服务器上所有和关键字相关的包
* yum -y install 包名 # 安装
    - -y自动回答yes
    - install 安装
* yum -y update 包名 # 升级
* yum remove 包名 # 卸载

*服务器使用最小化安装，用什么装什么，尽量不卸载*

yum软件组管理命令
* yum grouplist # 列出所有软件组列表
* yum groupinstall 软件组名 # 安装指定软件组，组名可以用grouplist查询出来
* yum groupremove 软件组名 # 卸载指定软件组名

### 源码包

1. 安装在指定位置，一般是```/usr/local/软件名```
2. 安装注意事项  
   * 源代码保存位置：```/usr/local/src/```
   * 软件安装位置：```/usr/local/```
   * 软件配置与检查 ```./configure```  
        - 定义需要的功能项
        - 检测系统环境是否符合安装要求
        - 把定义好的功能选项和检测系统环境的信息都写入Makefile文件，用于后续的编辑
        ```bash
        ./configure --prefix=/usr/local/软件名 # 产生Makefile文件
        make # 编译
        # make clean 如果编译报错，使用这个命令清除编译缓存文件
        make install # 安装
        # 安装出错首先make clean，再删除这个软件目录
        ```

## 权限管理

* chmod # 改变权限
* chown 用户名 文件名 # 改变所有者
* chgrp 组名 文件名 # 改变所属组

文件默认权限
* 文件不能默认建立为执行文件，必须手工赋予执行权限
* 文件默认权限最大为666
* **默认权限需要换算成字母再相减**
* 建立文件之后的默认权限，为666减去umask的值

目录默认权限
* 目录默认最大权限为777

修改umask值
```bash
umask 0022 # 临时生效
vim /etc/profile # 永久
```

### ACL权限

为了解决用户身份不够用的问题

查看分区的ACL权限是否开启  
```bash
dumpe2fs -h /dev/sda5
# 查询指定分区详细文件系统信息
# -h 仅显示超级快中信息，而不显示磁盘块组的详细信息
```

临时开启分区ACL权限
```bash
mount -o remount,acl /
# 重新挂载根分区，并挂载加入ACL权限
```

永久开启分区ACL 权限
```bash
vim /etc/fstab
# default后加acl
mount -o remount /
# 重新挂载文件系统或者重启系统，使修改生效
```

查看ACL命令
```bash
getfacl 文件名
# 查看ACL权限
```

设定ACL权限  
setfacl 选项 文件名
* -m 设定ACL权限
* -x 删除指定的ACL权限
* -b 删除所有的ACL权限
* -d 设定默认ACL权限
* -k 删除默认ACL权限
* -R 递归设定ACL 权限