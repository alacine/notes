## libvirt

需要安装 libvirt、ebtables(default NAT work)，同时启动 libvirtd 的守护进程，还要把当前用户添加到 
libvirt 的用户组里面

参考
[Arch Wiki Libvirt](https://wiki.archlinux.org/title/Libvirt)

### Server

KVM/QEMU, LXC, VirtualBox, Xen

本文 Client 以 KVM/QEMU 为例

### Client

#### virsh(CLI)

所属包: `libvirt`

默认情况下，创建的虚拟机位置为
* qemu:///system 为 `/var/lib/libvirt/images/`
* qemu:///session 为 `${HOME}/.local/share/libvirt/images/`

1. domain(指具体的虚拟机)

查看，后续的命令也要区分 system 和 session，root 用户使用时默认为 system，
一般用户为 session
```bash
virsh list --all
virsh -c qemu:///system list --all
```
当然还有修改默认的方法
```bash
export LIBVIRT_DEFAULT_URI="qemu:///system"
```

输出样例
```
 Id   Name            State
--------------------------------
 -    fedora          shut off
```

gracefully shutdown
```bash
virsh shutdown fedora
```

stop(power off)
```bash
virsh destroy fedora
```

delete
```bash
virsh undefine fedora
virsh undefine fedora --remove-all-storage
```
第一个删除是删除该虚拟机的信息，不会实际删除虚拟机文件，
第二个会删文件

要删除文件也可直接`rm`，要自己找到文件位置
```bash
virsh domblklist fedora  --details

virsh dumpxml fedora
```

2. 网络

启动前要确保网络可用
```bash
virsh net-start default
# 也可设置自启动
virsh net-autostart default
```

查看网络信息，注意这里的输出中是 Hostname，而不是 domain
```bash
virsh net-dhcp-leases default
```

查看虚拟机 ip，这里是 domain 对应 ip
```bash
virsh domifaddr fedora
```

如果发现 domain 存在但是输出是空的，说明当前虚拟机管理程序无法通过`lease`获取
网络信息（默认`--source 为 lease`），可换用`arp`或`agent`获取。其中`agent`
需要 vm 内安装配置并启用相关 guest agent 的服务，（尤其是qemu，对应 qemu-guest-agent 
软件包及同名服务，本文安装使用的 fedora 已经默认安装并启用了该服务。）。

```bash
# 通过 guest agent 获取
virsh domifaddr fedora --source agent
# 通过 arp 获取
virsh domifaddr fedora --source arp
```

#### virt-install(CLI)

```bash
virt-install --connect qemu:///system \
             --hvm \
             --name=fedora \
             --vcpus=2 \
             --ram=2000 \
             --disk size=20,format=qcow2,bus=virtio,cache=writeback \
             --os-variant=fedora34 \
             --accelerate \
             --cdrom=/home/ryan/Qemu/Fedora-Server-dvd-x86_64-34-1.2.iso \
             --network bridge=virbr0,model=virtio \
             --vnc \
             --vnclisten=0.0.0.0
```

`--cdrom`选项表示从光盘启动，用于安装，安装完成之后，CDROM 会依就保留关联在 VM 上，
但实际使用的 ISO 文件路径会弹出。

`-vnc`+`--vnclisten`可以默认开启 vnc，暴露并且映射到主机的端口（默认 5900）。

`--location`与`--cdrom`使用上类似，不过可以额外添加启动的内核参数及`initrd`，例如

```bash
virt-install --connect qemu:///system \
             --hvm \
             --name=${DOMAIN} \
             --vcpus=${VCPUS} \
             --ram=${RAM} \
             --disk size=${SIZE},format=qcow2,bus=virtio,cache=writeback \
             --os-type=linux \
             --os-variant=fedora34 \
             --accelerate \
             --nographics \
             --noautoconsole \
             --wait=-1 \
             --location=${ISO} \
             --network bridge=virbr0,model=virtio \
             --initrd-inject ${KS_CFG} \
             --extra-args "inst.ks=file:/ks.cfg console=tty0 console=ttyS0,115200n8"
```

`--os-variant`指定系统类型，这样会有对应的优化，非常建议加上。具体要怎么写，可
以用命令来查看。没有的话就写`auto`了。
```bash
osinfo-query os
```

`--nographics`字面意思，无图形界面启动，用了这个当前终端默认会连入 vm 内；

`--noautoconsole`及不自动连入 vm，只要启动成功命令行会恢复到交互模式，这样可以
方便配置了自动安装的系统。但会有个问题，系统安装完成后，一般需要重启，而无图形
界面的情况下，这个重启是不会生效的，需要手动启动；

`--wait`等待安装完成的时间，单位是分钟，负数表示一直等到安装完成。使用负数和
上述`--noautoconsole`就可以使系统自动安装步骤中重启操作不会丢失了。

> initrd: 一个临时文件系统，它在启动阶段被 Linux 内核调用。主要用于当根文件系统被挂
> 载之前，进行准备工作。还有一种类似技术叫 initramfs，和本文主要内容无关，只是提一下。
> （[参考维基百科](https://zh.wikipedia.org/wiki/Initrd)）

> 参数解释 console=ttyS0,115200n8: https://elinux.org/Serial_console
>
> 更多内核参数: https://www.kernel.org/doc/html/v5.0/admin-guide/kernel-parameters.html

另外注意，使用`--location`依赖`isoinfo`和`cpio`这两个工具，分别属于软件包`genisoimage`
（Arch Linux 中为`cdrtools`）、和`cpio`。如果缺少这个依赖，会有类似以下报错
```
ERROR    [Errno 2] No such file or directory: 'isoinfo'
```
或者
```
ERROR    [Errno 2] No such file or directory: 'cpio'
```

*DEMO*

这里准备了一个 demo，本文同目录下有一个[ks.cfg](./ks.cfg)和一个
[Makefile](./Makefile)，安装完成之后有两个用户`root`和`demo`，
密码均为`abcdef`
```bash
# 安装
make
# 启动
make start
# 停止
make stop
# 删除（包括文件）
make clean
```

#### Virtual Machine Manager(GUI)

所属包: `virt-manager`

除了 GUI 操作外，之前通过`virt-install`安装的虚拟机也可以使用下面的方法连接打开
```bash
virt-manager -c qemu:///system --show-domain-console fedora
```


### QA

如何使用桥接网络

使用无线网络的时候似乎不能使用桥接模式，使用有线模式下面的文章看起来靠谱
[[Debian10]使用KVM虚拟机并配置桥接网络](https://www.cnblogs.com/DouglasLuo/p/12731591.html)
