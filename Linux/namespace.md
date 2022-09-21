## Linux Namespaces (命名空间)

```bash
man 7 namespaces
```

> 命名空间将全局系统资源包装在一个抽象中，使命名空间的进程看起来他们拥有自己的全
> 局资源的隔离实例，对全局资源的更改对属于命名空间成员的其他进程可见，此外的进程
> 不可见。命名空间的一种用途是实现容器。

Namespaces types

| Namespaces | Isolates                                        |
|------------|-------------------------------------------------|
| Cgroup     | Cgroup root directory                           |
| IPC        | System V IPC, POSIX message queues (进程进通信) |
| Network    | Network devices, stacks, ports, etc. (网络)     |
| Mount      | Mount points (文件系统挂载点)                   |
| PID        | Process IDs (进程 ID)                           |
| Time       | Boot and monotonic clocks                       |
| User       | User and group IDs (用户各用户组)               |
| UTS        | Hostname and NIS domain name (主机名和域名信息) |

> NIS: Network Information Service

```bash
ls -l /proc/$$/ns
```

## container(未完成)

利用 namespace 手动创建容器

1. 使用 unshare 来做隔离操作
2. 由于直接使用 unshare 隔离出来的网络不能访问外部，因此网络的 namespace 单独创建
3. 创建 cgroup 来控制系统资源的使用
4. 准备一个可以在上述 namespace 中可以操作的环境(这里使用 ubuntu 的 docker 镜像)

#### 1. unshare

具体参数和用法直接看 `--help`
```bash
unshare -uimpn -f bash
```
这样其实就已经完成了，单独创建了 uts、ipc、mount、pid、net 的 namespace 提供给后
面的 bash 运行，不过此时在里面运行的命令都来自与本机，网络也不可用，也没有资源使
用的限制

#### 2. 创建网络 namespace

在主机上创建网络 namespace 并做相关配置
```bash
ip netns add ns0
ip link add veth0 type veth peer name veth1
ip link set veth1 netns ns0
ip link set dev veth0 up

brctl addbr br0
brctl addif br0 veth0
ip addr add 172.27.0.1/16 dev br0
ip link set dev br0 up

ip netns exec ns0 ip addr add 172.27.0.2/16 dev veth1
ip netns exec ns0 ip link set dev veth1 up
ip netns exec ns0 ip route add default via 172.27.0.1
# 也可以先切换 namespace 再操作
# ip netns exec bash
# > ip addr add / ip link set

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -s 172.27.0.0/16 ! -o br0 -j MASQUERADE
```

验证
```bash
ip netns exec ns0 ping 172.27.0.1
ip netns exec ns0 ping 114.114.114.114
ip netns exec ns0 ping www.baidu.com
ip netns exec ns0 python -m http.server 8000 &
curl http://172.27.0.2:8000
```
> 这里还可以再把 python 的 http.server 的端口印射到宿主机上来让外部访问

顺便记录一些反向操作
```bash
ip netns del ns0
ip link set dev veth0 down
ip link del dev veth0

brctl delbr br0
brctl delif br0 veth0
# 查看 iptables
iptables -t nat -L -n --line-number
# 删除编号为 1 的规则
iptables -t nat -D OUTPUT 1
```


#### 3. 创建 cgroup namespace

在前面提到的参考文档
[kevin — linux之手动实现容器](https://blog.liu-kevin.com/2020/11/07/linuxzhi-shou-dong-shi-xian-dockerwen-jian-ge-chi/)
及[huweicai - 手动实现一个Linux容器](https://huweicai.com/run-linux-container-manual/)
中，都有这样的操作
> 在 `/sys/fs/cgroup/cpu` 中创建目录 `docker`/`my-container`

然而我的环境中没有 `/sys/fs/cgroup/cpu` 这个目录，查了 cgroup 的 man page(`man cgroups`)
得知 cgroup 有两个版本 v1、v2，以下将使用 v2 版本，v1 版本的可以参照上面的博客的做法。

[目前 cgroup 使用 v2 的发行版](https://github.com/opencontainers/runc/blob/main/docs/cgroup-v2.md#cgroup-v2)

按照 RedHat 的文档来创建 v2 版本的 cgroup
[Chapter 20. Using cgroups-v2 to control distribution of CPU time for applications](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/using-cgroups-v2-to-control-distribution-of-cpu-time-for-applications_managing-monitoring-and-updating-the-kernel#mounting-cgroups-v2_using-cgroups-v2-to-control-distribution-of-cpu-time-for-applications)

在 `/sys/fs/cgroup/` 目录下查看 `cgroup.subtree_control`
```bash
cat /sys/fs/cgroup/cgroup.subtree_control
```
```
memory pids
```
如果里面没有 `cpu` 和 `cpuset`，则手动添加
```bash
echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control
echo "+cpuset" >> /sys/fs/cgroup/cgroup.subtree_control
```
```bash
cat /sys/fs/cgroup/cgroup.subtree_control
```
```
cpuset cpu memory pids
```

单独创建一个目录 `demo` 用来为某个进程配置 cgroup 信息，里面会自动创建 cgroup 文
件(之后要改的就是这些文件，另外 `demo/cgroup.controllers` 中此应该包含 `cpu` 和
`cpuset`，因为它继承自前面提到的 `/sys/fs/cgroup/cgroup.subtree_control`)
```bash
mkdir /sys/fs/cgroup/demo
ls /sys/fs/cgroup/demo
```
> 如何删除 demo 目录，为什么 root 用户 `rm -rf /sys/fs/cgroup/demo` 也没有权限？  
> 试试 `rmdir /sys/fs/cgroup/demo`
> Why: https://unix.stackexchange.com/a/697526

设置 demo 的子组只能控制 `cpu` 和 `cpuset` 再在里面创建一个只用来控制 cpu 资源的子组
```bash
echo "+cpu" >> /sys/fs/cgroup/demo/cgroup.subtree_control
echo "+cpuset" >> /sys/fs/cgroup/demo/cgroup.subtree_control
mkdir /sys/fs/cgroup/demo/abc
```

限制 cpu 核心数量和 cpu 的负载(man cpuset)
```bash
echo "1" > /sys/fs/cgroup/demo/abc/cpuset.cpus
# 表示在 1000000 ms 的时间周期内可占用 200000 ms 的时间
echo "200000 1000000" > /sys/fs/cgroup/demo/abc/cpu.max
```

写入需要控制的进程(假设 pid 为 1234、2345)
```bash
echo 1234 > /sys/fs/cgroup/demo/abc/cgroup.procs
echo 2345 > /sys/fs/cgroup/demo/abc/cgroup.procs
```
> RedHat 的文档中确实是这样写的，这里为什么两条 echo 用的都是 `>` ？
> 而最终这个文件中的内容是
```
1234
2345
```


#### 4. 准备运行环境

直接借用 docker 的镜像里的 layer 来做最下层的文件系统(rootfs)，另外最后的验证步
骤中需要用到一些网络 cli 工具，纯 ubuntu 的镜像里面是没有这些工具的，因此这里先
借用 docker 来创建一个包含工具的最底层文件系统
(当然也可以直接拷贝宿主操作系统的二进制文件，但可能会遇到需要缺少依赖的链接库的
问题，也需要手动拷贝这些依赖的内容，这里偷懒直接借用 docker 来做这件事了，当然，
后面的 namespace 隔离的部分不会使用 docker)

```dockerfile
FROM ubuntu

RUN apt-get update && \
    apt-get -y install iproute2 iputils-ping && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

```bash
docker build . -t demo
docker save demo -o demo.tar
```

分别创建三个目录 `rootfs`, `upperfs`, `workfs` (具体名称无所谓)

解开 demo.tar，从里面找到所有的 layer.tar，按照顺序全部解开到 rootfs，
把这个目录作为容器的根目录

挂载(这里使用了现成的 overlayfs，需要先手动加载 overlay 这个内核模块)
```bash
mount -t overlay -o lowerdir=./rootfs,upperdir=./upperfs,workdir=workfs overlay ./rootfs
```

隔离 namespace 后 chroot
```bash
unshare -muinp -f chroot ./rootfs /bin/bash --login
```

此时的通过 ps 还无法查看进程
```
# ps aux
Error, do this: mount -t proc proc /proc
```
执行上述挂载 proc 的命令后
```
# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.2   5044  4028 ?        S    08:23   0:00 /bin/bash --login
root           8  0.0  0.1   7480  3280 ?        R+   08:30   0:00 ps aux
```


#### 5. 验证
进入容器
```bash
ip netns exec ns0 unshare -muip -f chroot ./rootfs usr/bin/bash
```

此时还缺少域名解析，在容器中 resolve.conf 中写入 DNS 即可
```bash
cat << EOF >> /etc/resolv.conf
nameserver 8.8.4.4
nameserver 8.8.8.8
EOF
```

再尝试一下 `apt update`，出现下面的问题
```
/usr/bin/apt-key: 95: cannot create /dev/null: Permission denied
```

重新手动创建即可
```bash
rm -f /dev/null; mknod -m 666 /dev/null c 1 3
```


#### 参考
- [namespaces man page](https://man7.org/linux/man-pages/man7/namespaces.7.html)
- [cgroups man page](https://man7.org/linux/man-pages/man7/cgroups.7.html)
- [Chapter 20. Using cgroups-v2 to control distribution of CPU time for applications](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/using-cgroups-v2-to-control-distribution-of-cpu-time-for-applications_managing-monitoring-and-updating-the-kernel#mounting-cgroups-v2_using-cgroups-v2-to-control-distribution-of-cpu-time-for-applications)
- [overlayfs](https://kernel.org/doc/html/latest/filesystems/overlayfs.html#directories)
- [opencontainers/runc cgroup-v2](https://github.com/opencontainers/runc/blob/main/docs/cgroup-v2.md)
- [kevin — linux之手动实现容器](https://blog.liu-kevin.com/2020/11/07/linuxzhi-shou-dong-shi-xian-dockerwen-jian-ge-chi/)
- [huweicai - 手动实现一个Linux容器](https://huweicai.com/run-linux-container-manual/)
