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

### Tips

文件的详细信息
```bash
stat filename
```

Makefile 中递归 wildcard 实现
```
rwildcard = $(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

target: $(call rwildcard,./,*.go)
    commands
```

`--`表示停止接受 flag 参数，后续出现的参数一律视为文件名称和普通的参数，例如在
`oh-my-zsh`中，会把`-`作为`cd -`的别名，具体做法如下
```bash
alias -- -='cd -'
```
同样，要查看也是一样
```bash
alias -- -
```

shell 获取上个命令的最后一个参数`ALT+.`


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

