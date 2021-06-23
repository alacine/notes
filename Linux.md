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
