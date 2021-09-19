## Kubernetes

参考文档
* [kubernetes docs](https://kubernetes.io/zh/docs/tutorials/)
* [Kubernetes Handbook](https://jimmysong.io/kubernetes-handbook/)

### 概念

#### 集群

* Master 调度整个集群
    - API Server(对应`kube-apiserver`): 对外暴露的 API 接口服务，存储 kube-proxy
      上传上来的信息（不是存储在内存中，存储在共享存储 etcd 中）
    - Scheduler: 观测，调度每个 node 上可用的资源，对应`kube-scheduler`
    - Controller Manager: 监控管理 Node 上的所有控制器，
      对应`kube-controller-manager`
    - etcd: key-value 存储系统
* Node 负责运行应用
    - 控制器: 对应`kubelet`
    - 容器运行时: 对应`docker`
    - kube-proxy: 当 Pod 发生变化，与 master 的 API Server 通信

以 minikube 为例子，Master 上运行的相关进程有
```
/var/lib/minikube/binaries/v1.22.1/kubelet
kube-controller-manager
kube-apiserver
kube-scheduler
etcd
/usr/local/bin/kube-proxy
```

Node 上运行的相关进程有
```
/var/lib/minikube/binaries/v1.22.1/kubelet
/usr/local/bin/kube-proxy
```

当然不止这些进程，结果做了`grep kube`，

Master 负责管理整个集群。Master 协调集群中的所有活动，例如调度应用、维护应用的
所需状态、应用扩容以及推出新的更新。

Node 是一个虚拟机或者物理机，它在 Kubernetes 集群中充当工作机器的角色，每个 Node
都有 Kubelet，它管理 Node 同时也是 Node 和 Master 通信的代理。Node 还有处理容器
操作的工具，例如 Docker 或者 rkt。处理生产级流量的集群至少有三个 Node。

#### 组件

1. Pod 及其抽象层 Service
2. 控制器
3. 标签选择器

#### API 对象

每个 API 对象有大类属性：元数据 metadata、规范 spec 和状态 status。元数据是用来
标识 API 对象的，每个对象至少有三个元数据：namespaces、name、uid；

**POD**

部署应用或这服务的最小单元，可以支持多个容器。在 Kubernetes Handbook 中以软件
仓库为例子，一个 Nginx 容器用来发布软件，另一个容器专门用来从源仓库中同步数据，
两个容器功能不一样，也不太可能由同一个团队开发，但是这两个服务一起工作才能提供
一个完整的服务；这种情况下，就可以组合成一个为服务。

> 我遇到的 Pod 内多个容器的一种情况是这样的：最终运行时对外服务只有一个容器在运
> 行，但是在这个容器运行之前，会先启动另一个用来做初始化的容器，这个容器会对统一
> 挂载的存储目录做一些权限修改的操作，这个是公司内的标准，这么做可以确保一些统一
> 的操作方便执行，比如日志采集。

POD 内所有容器共享同一个网络[命名空间](../Linux/namespace.md)，即`Network`、
`UTS`、`IPC`共享，其它隔离。

每个 POD 有标签，通过标签选择器(Lable Selector)来找到符合条件的 POD。并不是只有
POD 才有标签，其他的资源也有标签。

**副本控制器 RC**

Replication Controller；Kubernetes 集群中最早保证 Pod 高可用的 API 对象。通过
监控运行中的 Pod 来保证集群中运行指定数目的 Pod 副本；多了就杀掉一些，少了就新
增加一下，只适用于 长期伺服型的业务类型

**副本集 RS**

Replica Set；新型 RC，支持更多的匹配模式，不会单独使用，作为 Deployment 的理想
状态参数使用。

**Deployment**

表示一次 Kubernetes 集群的更新操作，可以是新增一个服务，也可以是更新一个服务。
只能用于无状态

> 无状态应用是不将数据或应用状态存储到集群或永久性存储空间的应用。相反，
> 该应用将数据和应用状态保留在客户端，从而使无状态应用更具可伸缩性。

**StatefulSet**

有状态应用

**DaemonSet**

**Job, Cronjob**

### kubectl 基本使用

[官方常用命令整理](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)


#### 用法

按照[官方教程](https://kubernetes.io/zh/docs/tutorials/)本地使用 minikube
过一遍，[看这个](./tutorial.md)

一般作用类似命令的用法是类似的，可以尝试着试试把一个命令的用法参数照搬到
另一个上去试试看，不行了再看文档

* 获取信息类型的子命令（get, describe, logs）

get 获取基本信息，describe 详细信息；

第一个参数为资源类型，第二个参数为具体某个资源的名称，没有第二个参数时，
则会输出所有符合类型的资源信息，例如
```bash
kubectl get nodes
kubectl get deployments
kubectl get pods

kubectl describe nodes
kubectl describe deployments
kubectl describe pods
```

后继续加具体的名称，就是再筛选一遍名称
```bash
kubectl get nodes minikube-m02
kubectl describe pods kubernetes-bootcamp-57978f5f5d-q9xtj
```

条件筛选，也适用于其他用来查询的子命令
```bash
# 筛选 label app=nginx 的 pods
kubectl get pods -l app=nginx
```

自定义模板输出
```bash
kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'
```

logs 打印某个 pod 和其中的容器的日志

```bash
# 输出 pod: nginx 中的日志，仅一个容器的日志
kubectl logs nginx

# 和 tail -f 类似
kubectl logs -f nginx

# pod: nginx 中所有容器的日志
kubectl logs nginx --all-containers=true

# 筛选 label app=nginx 的 pods 中的所有容器的日志
kubectl logs -l app=nginx --all-containers=true
```

```bash
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
```

* 其它一些命令

exec 在某个 pod 中执行命令
```bash
kubectl exec nginx-6799fc88d8-jzvvj -- ls
```

```bash
kubectl cluster-info
```

```bash
# 启动一个 http 服务代理 kubernetes API，并且调用
kubectl proxy
curl http://localhost:8001/api/v1/namespaces/default/pods/nginx-6799fc88d8-jzvvj
```

