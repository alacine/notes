## QEMU

参考
[QEMU: A proper guide!](https://www.youtube.com/watch?v=AAfFewePE7c&t=601s)
[Arch Wiki](https://wiki.archlinux.org/title/QEMU_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

基本步骤

首先创建一个用于存储的硬盘镜像，两种格式`qcow2`(动态分配)，`raw`(固定
大小)，`-f`指定格式
```bash
qemu-img create -f raw image_file 20G
```

启动，`-m`内存，`-cpu`中`host`表示模拟 HOST 机器的 CPU，后面的部分是 archwiki 中
关于启动 windows 的建议，`-smp`指定 CPU 核心数，`-vga`图形后面的`virtio`目前只支持 Linux
，`display`显示，其中`gl`表示 OpenGL

```bash
#!/bin/bash
qemu-system-x86_64 \
    -enable-kvm \
    -cdrom isofile.iso \
    -boot menu=on \
    -drive file=win11_img.raw \
    -m 6G \
    -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
    -smp 4 \
    -vga virtio \
    -display sdl,gl=on \
    -device ich9-intel-hda
```

这是第一次安装启动，系统安装完成后，`-cdrom`就可以不再使用了

图形化界面 virt-manager

需要安装 libvirt、ebtables，同时启动 libvirtd 的守护进程，还要把当前用户添加到 
libvirt 的用户组里面
