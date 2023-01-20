## 收藏链接

* [Unix as IDE](https://blog.sanctum.geek.nz/series/unix-as-ide/)
* [Bash shell expansion](https://blog.sanctum.geek.nz/bash-shell-expansion/)

## 环境变量

| 变量                                    | 作用 | 说明                              |
|-----------------------------------------|------|-----------------------------------|
| `TZ`                                    | 时区 | 例如`Asia/Shanghai`, `US/Eastern` |
| `HTTP_PROXY`,`HTTPS_PROXY`, `ALL_PROXY` | 代理 |                                   |

## 进程相关

获取某个进程的路径
```
readlink -f /proc/PID/exe
```

获取进程的当前工作路径
```
pwdx PID
```

获取进程使用的环境变量
```
cat /proc/PID/environ
```
或者用`strings`(一些字符在`cat`不能正常输出, 这里用`strings`可以输出换行)
```
strings /proc/PID/environ
```

进程打开的文件描述符
```bash
ls /proc/PID/fd
```

进程启动的线程
```bash
ls /proc/PID/task
```

当前启动的自定义的内核参数
```bash
cat /proc/cmdline
```

### Tips

-----

文件的详细信息
```bash
stat filename
```

-----

Makefile 中递归 wildcard 实现
```
rwildcard = $(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

target: $(call rwildcard,./,*.go)
    commands
```

-----

`--`表示停止接受 flag 参数，后续出现的参数一律视为文件名称和普通的参数，例如在
`oh-my-zsh`中，会把`-`作为`cd -`的别名，具体做法如下
```bash
alias -- -='cd -'
```
同样，要查看也是一样
```bash
alias -- -
```

-----

shell 获取上个命令的最后一个参数`ALT+.`

-----

用 SSH 连接的时候出现的问题
```
no matching host key type found. Their offer: ssh-rsa
```

解决方法就是指定加上对应的加密算法了
```bash
ssh -o HostKeyAlgorithms=+ssh-rsa xxx@xxx
```

如果要写在`.ssh/config`中的话，也是加上一行对应的内容，比如这样
```
Host miwifi
    User root
    Hostname 192.168.31.1
    Port 22
    HostkeyAlgorithms +ssh-rsa
```

-----

Swapfile
- [ArchWiki Swap](https://wiki.archlinux.org/title/Swap#Swap_file_creation)
- [ArchWiki Btrfs](https://wiki.archlinux.org/title/Btrfs#Swap_file)
```bash
# btrfs 需要先做一下操作
truncate -s 0 /swapfile
chattr +C /swapfile
btrfs property set /swapfile compression none
# 常规创建 swapfile 的方式
fallocate -l 16G /swapfile
chmod 0600 /swapfile
mkswap /swapfile
swapon /swapfile
```

---

关闭系统响铃

`/etc/modprobe.d/nobeep.conf` 写入
```
blacklist pcspkr
```

## GUI 相关

使用 AMD 显卡时，DE 自带的亮度调节无效

启动时添加内核启动参数
```
amdgpu.backlight=0
```

临时使用 xrandr 调节，如下所示，当然必须是 X 的才有效，wayland 不可以，需要找
对应的管理工具调节
```bash
xrandr --output eDP --brightness 0.8
```

---

默认浏览器

在 DE 自带的设置里修改外，还有一个需要改(需要重新登录)

```bash
xdg-settings get default-web-browser
xdg-settings set default-web-browser firefox.desktop
```

---

[wayland 无鼠标问题](https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/3189)
```
Failed to render cursor bufferit failed (pageflip): Device or resource busyvariab
```
设置环境变量即可
```bash
WLR_NO_HARDWARE_CURSORS=1 sway
```

---

[键盘 Fn 按键问题(Keychron)](https://venthur.de/2021-04-30-keychron-c1-on-linux.html)

以我的键盘中 F11 对应的媒体功能是音量+，无论按下 Fn + F11 还是单独按 F11，实际
表现出来的效果都是音量+

临时解决方案
```bash
# as root:
echo 2 > /sys/module/hid_apple/parameters/fnmode
```

永久方案 `/etc/modprobe.d/hid_apple.conf` 写入
```
options hid_apple fnmode=2
```
然后执行
```bash
# as root
update-initramfs -u -k all
```
