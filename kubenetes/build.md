## kubernetes 搭建

### minikube

### kubeadm

这里先放一个带了环境配置的虚拟机，当前目录 make 可生成。

大概要安装哪些包，要做哪些操作，在[fedora-kube.cfg](./fedora-kube.cfg)
这个 kickstart 自动化安装配置中写了脚本，更细致段过程以后再写吧。

这里先记录问题：

1. swap 禁用问题

由于 kubernetes 不支持 swap，因此在搭建的时候，最好关了 swap 或者禁用了
```bash
# 这是临时关闭
swapoff -a

# 去掉 swap 分区的挂载，防止开机时再创建 swap，一些用 CentOS 的教程会这么写
sed -ri 's/.*swap.*/#&/' /etc/fstab
```

但是我当时虚拟机选了 fedora 这个发型版本(fedora34)，系统安装完成之后 fstab 中
原本就没有 swap，用`swapoff -a`临时关闭后也会马上自动被打开，输出以下内容。
```
[ 3289.364617] zram0: detected capacity change from 4046848 to 0
[ 3294.403999] zram0: detected capacity change from 0 to 4046848
[ 3294.428933] Adding 2023420k swap on /dev/zram0.  Priority:100 extents:1 across:2023420k SSFS 
```

在 [fedora 文档](https://fedoraproject.org/wiki/Changes/SwapOnZRAM#How_can_it_be_disabled.3F)
里查到了，zram 自动创建了 swap，并且是不依赖与分区建立的，因此 fstab 里面肯定是
没有 swap 的内容了。

想要关掉 swap 按照文档里来就这么做。
```bash
# Immediately:
sudo systemctl stop swap-create@zram0

# Permanently:
sudo touch /etc/systemd/zram-generator.conf or sudo dnf remove zram-generator-defaults 
```

2. 仓库选择

初始化的时候想着网速问题就指定了国内阿里云的仓库
```bash
kubeadm init --image-repository=registry.aliyuncs.com/google_containers
# 或者
kubeadm init --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers
```
都有以下类似问题
```
error execution phase preflight: [preflight] Some fatal errors occurred:
        [ERROR ImagePull]: failed to pull image registry.aliyuncs.com/google_containers/coredns:v1.8.4: output: Error response from daemon: manifest for registry.aliyuncs.com/google_containers/coredns:v1.8.4 not found: manifest unknown: manifest unknown
, error: exit status 1
```

似乎可以先手动拉一个镜像，然后重新打一个 tag，[参考](https://github.com/kubernetes/minikube/issues/12021)，
不过我还是直接路由器走代理用默认的了。
