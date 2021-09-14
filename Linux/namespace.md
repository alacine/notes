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
