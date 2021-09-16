## kubernetes 搭建

### minikube

### kubeadm

这里先放一个带了环境配置的虚拟机，当前目录 make 可生成，之后进了虚拟机可以直接用
`kubeadm init`开始练习着用。

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

3. NotReady

```bash
kubectl get nodes
```
输出，注意其中的状态是`NotReady`
```
NAME            STATUS     ROLES                  AGE   VERSION
fedora-master   NotReady   control-plane,master   65m   v1.22.1
fedora-node     NotReady   <none>                 64m   v1.22.1
```
查看日志
```bash
journalctl -u kubelet
```
有以下信息
```
"Container runtime network not ready" networkReady="NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized"
```

kubeadm 在设计上并没有安装网络的解决方案，需要用户自行安装第三方符合 CNI 
(Container Network Interface)要求的网络解决方案，如 [flannel](https://github.com/flannel-io/flannel#deploying-flannel-manually)。
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

使用 flannel 时，记得在集群初始化的时候额外加参数(cidr: Classless Inter-Domain
Routing, 无类别域间路由)
```bash
kubeadm init --pot-network-cidr=10.244.0.0/16
```
忘了加，记得手动配置文件(/etc/kubernetes/manifests/kube-controller-manager.yaml)
里面加些配置并且重启一下 kubelet，[参考](https://github.com/flannel-io/flannel/issues/728#issuecomment-325347810)
```
--allocate-node-cidrs=true
--cluster-cidr=10.244.0.0/16
```
