## Docker

### docker 基本命令

> 镜像`Image`和容器`Container`的关系，就像是面向对象程序设计中的`类`和`实例`一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。

查看本地所有 images
```
docker images
```

获取 image
```
docker pull
```

创建 image
```
docker build
```

启动一个 container
```
docker run CONTAINER_ID
docker run -p 8888:80 -d nginx  # -p 80 端口映射到 8888, -d 将此程序作为守护进程运行
```

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

| 命令       | 用途                                                                |
|------------|---------------------------------------------------------------------|
| FROM       | base image                                                          |
| RUN        | 执行命令                                                            |
| ADD        | 添加文件(可以添加远程文件, 如添加 ftp 服务器上的文件)               |
| COPY       | 拷贝文件                                                            |
| CMD        | 执行命令                                                            |
| EXPOSE     | 暴露端口                                                            |
| WORKDIR    | 指定命令执行路径                                                    |
| MAINTAINER | 维护者                                                              |
| ENV        | 设定环境变量                                                        |
| ENTRYPOINT | 容器入口(如果指定, 那么 CMD 所指定的字符串将变为 ENTRYPOINT 的参数) |
| USER       | 指定执行命令用户                                                    |
| VOLUME     | mount point(挂载卷)                                                 |

### 镜像分层

Dockerfile 中的每一行都产生一个新层

Dockerfile 中的内容是只读的, 生成 images 后, images 中的内容是可读写的

### Volume

提供独立于容器之外的持久化存储
