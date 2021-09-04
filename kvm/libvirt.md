## libvirt

参考
[Arch Wiki Libvirt](https://wiki.archlinux.org/title/Libvirt)

### Server

KVM/QEMU, LXC, VirtualBox, Xen

### Client

#### virsh(CLI)

所属包: `libvirt`

默认情况下，创建的虚拟机位置为
* qemu:///system 为 `/var/lib/libvirt/images/`
* qemu:///session 为 `${HOME}/.local/share/libvirt/images/`

1. domain(指具体的虚拟机)

查看
```bash
virsh list --all
virsh -c qemu:///system list --all
```

输出样例
```
 Id   Name            State
--------------------------------
 -    centos-stream   shut off
```

gracefully shutdown
```bash
virsh shutdown centos-stream
```

stop(power off)
```bash
virsh destroy centos-stream
```

delete
```bash
virsh undefine centos-stream
virsh undefine centos-stream --remove-all-storage
```
第一个删除是删除该虚拟机的信息，不会实际删除虚拟机文件，
第二个会删文件

要删除文件也可直接`rm`，要自己找到文件位置
```bash
virsh domblklist centos-stream  --details
```

2. 网络

启动前要确保网络可用
```bash
virsh -c qemu:///system net-start default
# 也可设置自启动
virsh -c qemu:///system net-autostart default
virsh -c qemu:///system net-dhcp-leases default
```

#### virt-install(CLI)

```bash
virt-install --connect qemu:///system \
             --hvm \
             --name=centos-stream \
             --vcpus=1 \
             --ram=1536 \
             --disk size=10,format=qcow2,bus=virtio,cache=writeback \
             --os-variant=auto \
             --accelerate \
             --cdrom=/home/ryan/Qemu/CentOS-Stream-8-x86_64-latest-dvd1.iso \
             --network bridge=virbr0,model=virtio
             #--vnc \
             #--vnclisten=0.0.0.0 \
```


#### Virtual Machine Manager(GUI)

所属包: `virt-manager`

除了 GUI 操作外，之前通过`virt-install`安装的虚拟机也可以使用下面的方法连接打开
```bash
virt-manager -c qemu:///system --show-domain-console centos-stream
```
