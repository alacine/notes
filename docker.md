## Docker

### docker 基本命令

> 镜像`Image`和容器`Container`的关系，就像是面向对象程序设计中的`类`和`实例`一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。

* image

查看本地所有 images
```
docker images
docker image ls
```

> docker images: Alias for docker image ls

获取 image
```
docker pull
```

创建 image
```
docker build
```

* container

启动一个 container
```
docker run CONTAINER_ID
docker run -p 8888:80 -d nginx  # -p 80 端口映射到 8888, -d 将此程序作为守护进程运行
docker run -it
```

> -i: 以交互模式运行容器
> -t: 分配一个伪输入终端

> docker container run: Alias for docker run

停止
```
docker stop CONTAINER_ID
```

删除 image
```
docker rmi CONTAINER_ID
```

查看当前运行
```
docker ps
```

查看历史运行
```
docker ps -a
```

> docker ps: Alias for docker container ls.

删除 container
```
docker rm CONTAINER_ID
```

在 host 和 container 之间拷贝文件
```
docker cp xxx CONTAINER_ID://path/to/file
```

提交改动, 生成一个新的 images
```
docker commit -m 'message' CONTAINER_ID nginx
```

### Docerfile 语法

| 命令       | 用途                                                                                                                                                |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| FROM       | base image                                                                                                                                          |
| RUN        | 执行命令                                                                                                                                            |
| COPY       | 拷贝文件(仅限本地文件)                                                                                                                              |
| ADD        | 添加文件(可以添加远程文件, 如添加 ftp 服务器上的文件, 隐式地做压缩包的解压操作, 例如`ADD a.tar /app`会直接将`a.tar`中的内容解压到镜像内的`/app`目录 |
| CMD        | 执行命令                                                                                                                                            |
| EXPOSE     | 暴露端口                                                                                                                                            |
| WORKDIR    | 指定命令执行路径                                                                                                                                    |
| MAINTAINER | 维护者                                                                                                                                              |
| ENV        | 设定环境变量                                                                                                                                        |
| ENTRYPOINT | 容器入口(如果指定, 那么 CMD 所指定的字符串将变为 ENTRYPOINT 的参数)                                                                                 |
| USER       | 指定执行命令用户                                                                                                                                    |
| VOLUME     | mount point(挂载卷)                                                                                                                                 |

### 镜像分层

Dockerfile 中的每一行都产生一个新层

Dockerfile 中的内容是只读的, 生成 images 后, images 中的内容是可读写的

### Volume

提供独立于容器之外的持久化存储

## docker-compose

多容器 app

* 构建
```bash
docker-compose build
```

* 启动
```bash
# -d: 守护进程
docker-compose up -d
# --build: 重新构建
docker-compose up --build
```

* 停止
```bash
docker-compose stop
```

* 删除生成的容器
```bash
# 这个不会删除生成网络
docker-compose rm
# 这个会删除网络
docker-compose down
```

### 其他问题

##### [如何判断当前是否在容器内部](https://stackoverflow.com/questions/20010199/how-to-determine-if-a-process-runs-inside-lxc-docker)

##### [alpine 中创建用户](https://stackoverflow.com/questions/49955097/how-do-i-add-a-user-when-im-using-alpine-as-a-base-image)

在 alpine 中没有`useradd`，但有`busybox`，其中包含`adduser`，还有注意这个和 Debian/Ubuntu 中的`adduser`略有不同

##### go build 后的二进制文件直接放在 alpine 中启动报错
```
standard_init_linux.go:228: exec user process caused: no such file or directory
```
默认情况下`CGO_ENABLED=1`会使得编译出的二进制文件依赖的是`/lib64/ld-linux-x86-64.so.2`，
如果`CGO_ENABLED=0`则不会，因此下面这样编译使得不依赖这个库
```bash
CGO_ENABLED=0 go build
```
当然，也可以直接安装`go`，这会把依赖直接安装上

还有一个比较简单的方法，[原文链接](https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker)
```
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
```

