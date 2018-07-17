## 常用命令

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
    - tar -ztvf 压缩包名 (查看压缩包中的内容)