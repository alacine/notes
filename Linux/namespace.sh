#!/usr/bin/env bash

# network namespace
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

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -s 172.27.0.0/16 ! -o br0 -j MASQUERADE

ping -c 3 172.27.0.2
ip netns exec ns0 ping -c 3 172.27.0.1
ip netns exec ns0 ping -c 3 114.114.114.114
ip netns exec ns0 ping www.baidu.com


# cgroup
echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control
echo "+cpuset" >> /sys/fs/cgroup/cgroup.subtree_control
cat /sys/fs/cgroup/cgroup.subtree_control

mkdir /sys/fs/cgroup/demo
echo "+cpu" >> /sys/fs/cgroup/demo/cgroup.subtree_control
echo "+cpuset" >> /sys/fs/cgroup/demo/cgroup.subtree_control
mkdir /sys/fs/cgroup/demo/abc

echo "1" > /sys/fs/cgroup/demo/abc/cpuset.cpus

echo "200000 1000000" > /sys/fs/cgroup/demo/abc/cpu.max
