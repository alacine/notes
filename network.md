## 网络命令入门

fping 批量主机扫描
* -a 只显示存活的主机(相反参数 -u)
* -g 支持主机段的方式 192.168.1.1 192.168.1.255 192.168.1.0/24
* -f filename 通过读取一个文件中的IP内容

hping 主机扫描

特点: 支持使用的TCP/IP数据包组装、分析工具

* -p 端口
* -S 设置TCP模式SYN包
* -a 伪造IP地址

traceroute

* 默认使用的是UDP协议(30000上的端口)
* `-T` 使用TCP协议
* `-p` 指定端口
* `-I` 使用ICMP协议介绍

批量主机服务扫描 nmap ncat
* 目的:
  - 批量主机存活扫描
  - 针对主机服务扫描
* 作用:
  - 更方便获取主机的存货状态
  - 更细致、智能获取主机服务侦查情况

nmap

|       扫描类型         |    描述      |        特点          |
|------------------------|--------------|----------------------|
|`-P` ICMP 协议类型      |ping 扫描     |简单、快速、有效      |
|`-sS` TCP SYN 扫描      |TCP 半开放扫描|高效、不易被检测、通用|
|`-sT` TCP connect() 扫描|TCP 全开放扫描|真实、结果可靠        |
|`-sU` UDP 扫描          |UDP 协议扫描  |有效透过防火墙策略    |

ncat

* `-w` 设置的超过时间
* `-z` 一个输入输出模式
* `-v` 显示命令执行过程

方式:
1. 基于tcp协议(默认) nc -v -z -w2 127.0.0.1 1-50
2. 基于udp协议-v nc -v -u -z -w2 127.0.0.1 1-50

常见的攻击方法:

1. SYN 攻击  
    利用 TCP 协议缺陷进行，导致系统服务停止响应，网络带宽跑满或者相应缓慢
2. DDOS 攻击  
    分布式访问拒绝服务攻击
3. 恶意扫描

SYN 类型 DDOS 攻击预防

1. 减少发送 syn+ack 包时重试次数  
    `sysctl -w net.ipv4.tcp_synack_retries=3`
    `sysctl -w net.ipv4.tcp_syn_retries=3`
2. SYN cookies 技术  
    `sysctl -w net.ipv4.tcp_syncookies=1`
3. 增加 backlog 队列  
    `sysctl -w net.ipv4.tcp_max_syn_backlog=2048`

Linux 下其他预防策略

1. 关闭 ICMP 请求  
    `sysctl -w net.ipv4.icmp_echo_ignore_all=1`
2. 通过 iptables防止扫描  
