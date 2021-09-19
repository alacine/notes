## 教程

使用本地的集群过一遍 kubernetes 的教程

### 创建一个 minikube 集群

安装`minikube`、`kubectl`软件包（Arch Linux `kubernetes-tools`组中包含了
软件包`crictl`、`critest`、`kubeadm`、`kubectl`，也可以直接装这个）

快速搭建一个可用的环境，这里使用[minikube kvm2](https://minikube.sigs.k8s.io/docs/drivers/kvm2/)
的方式创建了一个 Kubernetes 集群。minikube 在创建完成之后，会自动修改 kubectl 
的配置信息与其相连。

```bash
minikube start --drive=kvm2 --nodes=3
# ssh，默认第一个节点
minikube ssh
minikube ssh -n minikube-m02
```

> 备注：手动 ssh 的用户名称和密码是`docker`和`tcuser`

### 学习 Kubernetes 基础知识

#### 集群的基本信息

```bash
kubectl version
```

```
Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.2", GitCommit:"8b5a19147530eaac9476b0ab82980b4088bbc1b2", GitTreeState:"archive", BuildDate:"2021-09-16T09:21:16Z", GoVersion:"go1.17.1", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.1", GitCommit:"632ed300f2c34f6d6d15ca4cef3d3c7073412212", GitTreeState:"clean", BuildDate:"2021-08-19T15:39:34Z", GoVersion:"go1.16.7", Compiler:"gc", Platform:"linux/amd64"}
```

```bash
kubectl get nodes
```

```
NAME           STATUS   ROLES                  AGE   VERSION
minikube       Ready    control-plane,master   8d    v1.22.1
minikube-m02   Ready    <none>                 94m   v1.22.1
minikube-m03   Ready    <none>                 94m   v1.22.1
```

开启 api 代理
```bash
kubectl proxy
curl localhost:8001
```

#### 部署应用

```bash
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
```

```bash
kubectl get deployments
kubectl describe deployment
kubectl describe services/kubernetes-bootcamp
```

#### 查看、过滤

```bash
kubectl get pods

# 详细信息
kubectl describe pods

# 通过 proxy 访问
curl localhost:8001/api/v1/namespaces/default/pods/kubernetes-bootcamp-57978f5f5d-kw8nz

# 日志
kubectl logs $POD_NAME

# 执行操作
kubectl exec $POD_NAME -- env
kubectl exec -it $POD_NAME -- bash
```

查询
```bash
# 按标签过滤
kubectl get pods -l app=kubernetes-bootcamp

# 按名称空间过滤
kubectl get pods -n namespaces

# 阻塞终端，有变化就会再输出
kubectl get --watch pods 
```

手动添加标签
```bash
kubectl label pods kubernetes-bootcamp-57978f5f5d-ksmfk version=v1

# 添加完成后再查询
kubectl get pods -l app=kubernetes-bootcamp -l version=v1
```

#### 对外暴露

```bash
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
kubectl get services
```

```
NAME                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes            ClusterIP   10.96.0.1        <none>        443/TCP          8d
kubernetes-bootcamp   NodePort    10.108.172.180   <none>        8080:30513/TCP   2d20h
```

```bash
kubectl describe services/kubernetes-bootcamp
```

```
Name:                     kubernetes-bootcamp
Namespace:                default
Labels:                   app=kubernetes-bootcamp
Annotations:              <none>
Selector:                 app=kubernetes-bootcamp
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.108.172.180
IPs:                      10.108.172.180
Port:                     <unset>  8080/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30513/TCP
Endpoints:                10.244.0.4:8080,10.244.1.2:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

可以看到暴露在 30513 这个端口（可以指定，默认是随机的），现在可以在集群外访问

```bash
curl $(minikube ip):30513
```

#### 缩放

```bash
# 查看 ReplicaSet 副本集
kubectl get rs
```

注意看三个命令输出中的 NAME
```
❯ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   2/2     2            2           2d20h

❯ kubectl get rs
NAME                             DESIRED   CURRENT   READY   AGE
kubernetes-bootcamp-57978f5f5d   2         2         2       2d20h

❯ kubectl get pods
NAME                                   READY   STATUS    RESTARTS       AGE
kubernetes-bootcamp-57978f5f5d-ksmfk   1/1     Running   2 (121m ago)   15h
kubernetes-bootcamp-57978f5f5d-kw8nz   1/1     Running   0              107m
```

改变副本数量
```bash
# 增加
kubectl scale deployments/kubernetes-bootcamp --replicas=4
# 减少
kubectl scale deployments/kubernetes-bootcamp --replicas=2
```

#### 更新

```bash
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
```

更新完成之后再次查看，观察 Image 的变化
```bash
kubectl describe pods
```

同时，再看之前提到的三个命令的输出中在 NAME
```
❯ kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   2/2     2            2           2d21h

❯ kubectl get rs
NAME                             DESIRED   CURRENT   READY   AGE
kubernetes-bootcamp-57978f5f5d   0         0         0       2d21h
kubernetes-bootcamp-769746fd4    2         2         2       27m

❯ kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-769746fd4-clmsp   1/1     Running   0          27m
kubernetes-bootcamp-769746fd4-xnjkh   1/1     Running   0          22m
```

回滚，每次更新都会记录一个版本，可以回退到任意版本
```bash
# 回滚到最近的一个版本
kubectl rollout undo deployments/kubernetes-bootcamp
```

回滚之后，再次查看，可以看到 NAME 中的随机字符串也和之前的一样了
```
❯ kb get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   2/2     2            2           2d21h

❯ kb get rs
NAME                             DESIRED   CURRENT   READY   AGE
kubernetes-bootcamp-57978f5f5d   2         2         2       2d21h
kubernetes-bootcamp-769746fd4    0         0         0       44m

❯ kb get pods
NAME                                   READY   STATUS    RESTARTS   AGE
kubernetes-bootcamp-57978f5f5d-6d9wq   1/1     Running   0          2m46s
kubernetes-bootcamp-57978f5f5d-xrlvr   1/1     Running   0          2m48s
```


#### 删除

```bash
kubectl delete services -l app=kubernetes-bootcamp
```

#### 导入 yaml

根据 Yaml 中的内容，自动进行操作

```bash
# 文件
kubectl apply -f a.yaml b.yaml

# 目录
kubectl apply -k ./

# 删除也支持类似的操作
kubectl delete -k ./
```

#### 等待操作完成

等待默认 30 秒

```bash
# 等待直到 kubernetes-bootcamp Ready 为 true
kubectl wait --for=condition=ready pod -l app=kubernetes-bootcamp

# 等待直到 kubernetes-bootcamp Ready 为 false
kubectl wait --for=condition=ready=false pod -l app=kubernetes-bootcamp

# 等待 kubernetes-bootcamp 的删除操作完成
kubectl wait --for=delete pod -l app=kubernetes-bootcamp --timeout=60s
```

#### 创建 ConfigMap

```bash
# 创建名为 kubernetes-bootcamp 的 ConfigMap，内容为键值对 name=my-kboot
kubectl create configmap kubernetes-bootcamp --from-literal name=my-kboot
```

查看细致内容
```bash
kubectl create configmap --help
```

* `--from-literal`
* `--from-env-file`
* `--from-file`
