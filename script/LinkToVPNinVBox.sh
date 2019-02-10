#!/bin/bash
echo "Shell script for connecting to VPN in virtual box"
read -t 30 -p "1. connect 2. disconnect [1/2]? " choose
if [ $choose == 1 ]; then
    # add
    echo "==> connect"
    echo "  -> adding ip(192.168.137.2) for vboxnet0..."
    sudo ip addr add 192.168.137.2/24 dev vboxnet0
    echo "  -> adding route 172.16.0.0/12..."
    sudo ip route add 172.16.0.0/12 via 192.168.137.1
    echo "  -> adding route 202.197.224.00/24..."
    sudo ip route add 202.197.224.0/24 via 192.168.137.1
elif [ $choose == 2 ]; then
    # remove
    echo "==> disconnect"
    echo "  -> removing ip(192.168.137.2) for vboxnet0..."
    sudo ip addr delete 192.168.137.2/24 dev vboxnet0
    echo "  -> removing route 172.16.0.0/12..."
    sudo ip route delete 172.16.0.0/12
    echo "  -> removing route 202.197.224.00/24..."
    sudo ip route delete 202.197.224.0/24
else
    exit 10
fi
