## strace

观察系统调用
```bash
strace ./main

# 表格输出统计信息
strace -c ./main

# 持续输出
strace -f ./main

# 日志输出到 tlog.{PID} 中，-ff 表示同时追踪 fork 并且把 ./main 和
# strace 的输出分开
strace -o tlog -ff ./main
```

## exec

调用子进程，并替换当前进程

例如，在 zsh 中直接执行
```bash
bash
```

会进入 bash 中，但是退出后，会回到 zsh 中。
而下面的命令执行进入 bash 后，退出则不会回到 zsh 中。
```bash
exec bash
```

## ip

包含在软件包`iproute2`中，替换`net-tools`中的`ifconfig`

```bash
ip addr
ip -brief a

ip route
ip r
```

## ss

包含在软件包`iproute2`中，替换`net-tools`中的`netstat`

```bash
ss -tlp src :1080
ss -t dst 192.168.2.1:80
```

## tcpdump

TCP 抓包，需要`sudo`或者用 root
```bash
# -S 表示使用绝对序号，而不是使用相对序号
#    (区别是什么可以抓个三次握手的包观察 seq 和 ack 的值看看)
# -n 表示使用 ip 地址和端口号而不是域名和对应服务
# -i 指定网卡
tcpdump -Sn -i wlp3s0 host www.baidu.com

# -X 表示输出包中的具体内容
tcpdump -SXn -i wlp3s0 host www.baidu.com

tcpdump -nn -i wlp3s0 dst www.baidu.com and dst port 80
```

## fping 

批量主机扫描

* -a 只显示存活的主机(相反参数 -u)
* -g 支持主机段的方式 192.168.1.1 192.168.1.255 192.168.1.0/24
* -f filename 通过读取一个文件中的IP内容

## hping 

主机扫描

特点: 支持使用的TCP/IP数据包组装、分析工具

* -p 端口
* -S 设置TCP模式SYN包
* -a 伪造IP地址

## traceroute

* 默认使用的是UDP协议(30000上的端口)
* `-T` 使用TCP协议
* `-p` 指定端口
* `-I` 使用ICMP协议介绍


## nmap

| 扫描类型                 | 描述           | 特点                   |
|--------------------------|----------------|------------------------|
| `-P` ICMP 协议类型       | ping 扫描      | 简单、快速、有效       |
| `-sS` TCP SYN 扫描       | TCP 半开放扫描 | 高效、不易被检测、通用 |
| `-sT` TCP connect() 扫描 | TCP 全开放扫描 | 真实、结果可靠         |
| `-sU` UDP 扫描           | UDP 协议扫描   | 有效透过防火墙策略     |

## ncat(nc, netcat)

ncat ([用好你的瑞士军刀/netcat - 韦易笑的文章 - 知乎](https://zhuanlan.zhihu.com/p/83959309))

使用样例
```bash
$ nc -vz 127.0.0.1 8080
localhost [127.0.0.1] 8080 (http-alt) open
```
`v`表示显示详细信息，`z`表示不发送数据。

范围扫描，`-w3`设置 3 秒超时
```bash
$ nc -v -v -w3 -z 127.0.0.1 8075-8085
localhost [127.0.0.1] 8075: Connection refused
localhost [127.0.0.1] 8076: Connection refused
localhost [127.0.0.1] 8077 (mles): Connection refused
localhost [127.0.0.1] 8078: Connection refused
localhost [127.0.0.1] 8079: Connection refused
localhost [127.0.0.1] 8080 (http-alt) open
localhost [127.0.0.1] 8081 (sunproxyadmin): Connection refused
localhost [127.0.0.1] 8082 (us-cli): Connection refused
localhost [127.0.0.1] 8083 (us-srv): Connection refused
localhost [127.0.0.1] 8084 (websnp): Connection refused
localhost [127.0.0.1] 8085: Connection refused
Total received bytes: 0
Total sent bytes: 0

$ nc -v -w3 -z 127.0.0.1 8075-8085
localhost [127.0.0.1] 8080 (http-alt) open
```

启动端口监听
```bash
nc -l -p 8000
```
连接
```bash
nc 127.0.0.1 8000
```

测试 udp 会话
```bash
nc -u -l -p 8000
```
连接
```bash
nc -u 127.0.0.1 8000
```

文件传输

A主机
```bash
nc -l -p 8000 > image.png
```
B主机
```bash
nc 127.0.0.1 8000 < image.png
```

方式:
1. 基于tcp协议(默认) nc -v -z -w2 127.0.0.1 1-50
2. 基于udp协议-v nc -v -u -z -w2 127.0.0.1 1-50


## wrk wrk2 hey

*待补充*

## yq jq

yaml, json cli 输出美化

example.json
```json
{
    "a": 1,
    "b": {
        "c": true,
        "d": ["hello"]
    }
}
```

```bash
cat example.json | jq
# 或，注意这里的'.'表示筛选
jq . example.json
```

输出为
```json
{
    "a": 1,
    "b": {
        "c": true,
        "d": ["hello"]
    }
}
```

```bash
jq .b.d example.json
```

输出为
```json
[
  "hello"
]
```

yq
```bash
cat a.yaml | yq
# 或
yq . a.yaml
```
